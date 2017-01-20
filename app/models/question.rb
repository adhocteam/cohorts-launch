# frozen_string_literal: true
class Question < ActiveRecord::Base
  has_many :answers
  has_many :people, through: :answers
  validates :text, presence: true, uniqueness: true
end
