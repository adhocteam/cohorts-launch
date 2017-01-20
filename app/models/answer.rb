# frozen_string_literal: true
class Answer < ActiveRecord::Base
  belongs_to :question, required: true
  belongs_to :person, required: true
  belongs_to :submission
  validates :value, presence: true
end
