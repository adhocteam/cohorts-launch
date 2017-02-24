# frozen_string_literal: true
class Form < ActiveRecord::Base
  IGNORED_FIELDS = ['entry id', 'date created', 'created by', 'last updated', 'updated by',
                    'name', 'email', 'email address', 'phone', 'phone number', 'address'].freeze
  has_many :submissions
  has_many :questions
  has_many :answers, through: :submissions
  after_create :create_questions
  after_update :delete_questions, if: -> { hidden }

  # rubocop:disable Metrics/AbcSize
  def self.update_forms
    wufoo_forms = Cohorts::Application.config.wufoo.forms
    wufoo_forms.each do |wufoo_form|
      form = Form.where(hash_id: wufoo_form.details['Hash']).first_or_create do |new_form|
        new_form.hash_id = wufoo_form.details['Hash']
        new_form.name = wufoo_form.details['Name']
        new_form.description = wufoo_form.details['Description']
        new_form.url = wufoo_form.details['Url']
        new_form.created_on = Time.zone.parse(wufoo_form.details['DateCreated'])
        new_form.last_update = Time.zone.parse(wufoo_form.details['DateUpdated'])
      end
      if form.last_update != Time.zone.parse(wufoo_form.details['DateUpdated'])
        form.update(last_update: Time.zone.parse(wufoo_form.details['DateUpdated']))
        form.update_questions unless form.hidden
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def wufoo_data
    Cohorts::Application.config.wufoo.form(hash_id)
  end

  def wufoo_last_updated
    Time.zone.parse(wufoo_data.details['DateUpdated'])
  end

  def wufoo_fields
    wufoo_data.fields
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_question(field)
    return if IGNORED_FIELDS.include? field['Title'].downcase
    question = Question.new(
      form: self,
      field_id: field['ID'],
      text: field['Title'],
      datatype: field['Type'],
      version_date: last_update
    )
    case field['Type']
    when 'radio', 'select'
      question.choices = field['Choices'].map { |c| c['Label'] }
    when 'likert'
      choices = field['Choices'].map { |c| c['Label'] }
      field['SubFields'].each do |sf|
        Question.create(
          form: self,
          field_id: sf['ID'],
          text: sf['Label'],
          datatype: 'radio',
          choices: choices,
          version_date: last_update
        )
      end
    when 'shortname', 'address'
      question.subfields = field['SubFields'].map { |sf| sf['ID'] }
    when 'checkbox'
      question.subfields = field['SubFields'].map { |sf| sf['ID'] }
      question.choices = field['SubFields'].map { |sf| sf['Label'] }
    end
    question.save
  end

  def create_questions
    wufoo_fields.each { |field| create_question(field) }
  end

  def update_questions
    wufoo_fields.each do |field|
      question = Question.find_by(
        form: self,
        field_id: field['ID'],
        text: field['Title'],
        datatype: field['Type']
      )
      if question
        question.update(version_date: wufoo_last_updated)
      else
        create_question(field)
      end
    end
  end

  def delete_questions
    questions.each(&:delete)
  end
end
