# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class Submission < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :raw_content

  belongs_to :person
  validates :person_id, numericality: { only_integer: true, allow_nil: true }

  belongs_to :form

  has_many :answers
  has_many :questions, through: :answers

  enum form_type: {
    unknown: 0,
    signup: 1,
    screening: 2,
    availability: 3,
    test: 4
  }

  after_create :find_form_and_create_answers
  before_update :update_answers, if: -> { person_id_changed? }

  self.per_page = 15

  def form_hash
    @form_hash ||= JSON.parse(form_structure)['Hash']
  end

  def fields
    # return the set of fields that make up a submission
    #  { field_id => 'field description' }

    @fields ||= JSON.parse(field_structure)['Fields'].inject({}) do |acc, i|
      extract_field_data(acc, i)
    end
  end

  def field_labels
    fields.map { |field| field[1][:title] }
  end

  def field_values
    fields.map { |field| { text: field_label(field[0]), value: field_value(field[0]) } }
  end

  def field_label(field_id)
    fields[field_id][:title]
  end

  def field_value(field_id)
    value = []
    if fields[field_id][:subfields].any?
      fields[field_id][:subfields].each do |sf|
        value << JSON.parse(raw_content)[sf]
      end
    else
      value << JSON.parse(raw_content)[field_id]
    end
    if value.size == 1
      value.first
    elsif value.all?(&:empty?)
      ''
    else
      value.reject(&:blank?).join(', ')
    end
  end

  def form_name
    @form_name ||= JSON.parse(form_structure)['Name']
  end

  def form_email
    JSON.parse(field_structure)['Fields'].each do |field|
      return field_value(field['ID']) if field['Title'] == 'Email'
    end
    nil
  end

  def form_email_or_phone_number
    field_name_options = ['email', 'email or phone number', 'phone number']
    JSON.parse(field_structure)['Fields'].each do |field|
      if field_name_options.include? field['Title'].downcase
        return field_value(field['ID'])
      end
    end
    nil
  end

  def form_type_field
    field_name_options = ['form type']
    JSON.parse(field_structure)['Fields'].each do |field|
      if field_name_options.include? field['Title'].downcase
        return field_value(field['ID'])
      end
    end
    nil
  end

  def submission_values
    # return the field values in a nice format for search indexing
    fields.collect { |field_id, _desc| field_value(field_id) }.join(' ')
  end

  private

    def extract_field_data(data, field)
      data[field['ID']] = {
        title: field['Title'],
        type: field['Type'],
        subfields: (field['SubFields'] || []).collect { |sf| sf['ID'] }
      }
      # Rails.logger.debug("field: #{field['ID']} --> #{data[field['ID']]}")
      data
    end

    def find_form_and_create_answers
      Form.update_forms
      update(form: Form.find_by(hash_id: form_hash))
      entry = form.wufoo_entry(entry_id)
      form.questions.each do |question|
        answer = Answer.new(question: question, person: person, submission: self)
        if question.subfields.any?
          answer.subfields = question.subfields.map { |sf| entry[sf] }.compact
          answer.value = answer.subfields.join(', ')
        else
          answer.value = entry[question.field_id]
        end
        answer.save
      end
    end

    def update_answers
      entry = form.wufoo_entry(entry_id)
      form.questions.each do |question|
        answer = Answer.find_or_initialize_by(question: question, submission: self)
        answer.person = person
        if question.subfields.any?
          answer.subfields = question.subfields.map { |sf| entry[sf] }.compact
          answer.value = answer.subfields.join(', ')
        else
          answer.value = entry[question.field_id]
        end
        answer.save
      end
    end
end
