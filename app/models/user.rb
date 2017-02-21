# frozen_string_literal: true
class User < ActiveRecord::Base
  has_paper_trail

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, stretches: 10

  has_secure_token # for calendar feeds

  # for sanity's sake
  alias_attribute :email_address, :email

  def active_for_authentication?
    if super && approved?
      true
    else
      Rails.logger.warn("[SEC] User #{email} is not approved but attempted to authenticate.")
      false
    end
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  def approve!
    update_attributes(approved: true)
    Rails.logger.info("Approved user #{email}")
  end

  def unapprove!
    update_attributes(approved: false)
    Rails.logger.info("Unapproved user #{email}")
  end

  def full_name # convienence for calendar view.
    name
  end
end
