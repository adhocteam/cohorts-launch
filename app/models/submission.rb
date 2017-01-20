# frozen_string_literal: true
# == Schema Information
#
# Table name: submissions
#
#  id              :integer          not null, primary key
#  raw_content     :text(65535)
#  person_id       :integer
#  ip_addr         :string(255)
#  entry_id        :string(255)
#  form_structure  :text(65535)
#  field_structure :text(65535)
#  created_at      :datetime
#  updated_at      :datetime
#  form_id         :string(255)
#  form_type       :integer          default(0)
#

class Submission < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :raw_content

  belongs_to :person
  validates :person_id, numericality: { only_integer: true, allow_nil: true }

  has_many :answers
  has_many :questions, through: :answers

  enum form_type: {
    unknown: 0,
    signup: 1,
    screening: 2,
    availability: 3,
    test: 4
  }

  after_create :create_questions_and_answers

  self.per_page = 15

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

    def create_questions_and_answers
      person_attributes = Person.new.attributes.keys - %w(id created_at updated_at)
      relevant = field_values.reject do |f|
        person_attributes.include?(f[:text].parameterize('_')) || f[:value].empty?
      end
      relevant.each do |field|
        question = Question.where(text: field[:text]).first_or_create
        Answer.create(
          value: field[:value],
          question: question,
          person: person,
          submission: self
        )
      end
    end
end
