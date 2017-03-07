# frozen_string_literal: true
class LandingPage < ActiveRecord::Base
  belongs_to :tag
  accepts_nested_attributes_for :tag, reject_if: :tag_exists?

  has_attached_file :image, styles: { thumb: '128x96>', large: '1024x768>' }

  validate :lede_or_image_present
  validates :tag, presence: true, uniqueness: true
  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\z}

  private

    def lede_or_image_present
      if lede.blank? && image.blank?
        errors.add(:base, 'Specify a Lede or Image')
      end
    end

    def tag_exists?(attributes)
      self.tag = Tag.find_by(name: attributes['name'])
    end
end
