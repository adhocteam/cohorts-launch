# frozen_string_literal: true
class Comment < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :content
  belongs_to :commentable, polymorphic: true, touch: true
end
