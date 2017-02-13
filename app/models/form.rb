# frozen_string_literal: true
class Form < ActiveRecord::Base
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
    wufoo_data.flattened_fields
  end

  def create_questions
    wufoo_fields.each do |field|
      Question.create(
        form: self,
        field_id: field['ID'],
        text: field['Title'],
        datatype: field['Type'],
        version_date: last_update
      )
    end
  end

  def update_questions
    wufoo_fields.each do |field|
      question = Question.where(
        form: self,
        field_id: field['ID'],
        text: field['Title'],
        datatype: field['Type']
      ).first_or_create do |q|
        q.form = self
        q.field_id = field['ID']
        q.text = field['Title']
        q.datatype = field['Type']
      end
      question.update(version_date: wufoo_last_updated)
    end
  end

  def delete_questions
    questions.each(&:delete)
  end
end
