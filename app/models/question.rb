# frozen_string_literal: true
class Question < ActiveRecord::Base
  belongs_to :form
  has_many :answers
  has_many :people, through: :answers
  validates :text, presence: true
end
