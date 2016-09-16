# == Schema Information
#
# Table name: people
#
#  id                               :integer          not null, primary key
#  first_name                       :string(255)
#  last_name                        :string(255)
#  email_address                    :string(255)
#  address_1                        :string(255)
#  address_2                        :string(255)
#  city                             :string(255)
#  state                            :string(255)
#  postal_code                      :string(255)
#  geography_id                     :integer
#  primary_device_id                :integer
#  primary_device_description       :string(255)
#  secondary_device_id              :integer
#  secondary_device_description     :string(255)
#  primary_connection_id            :integer
#  primary_connection_description   :string(255)
#  phone_number                     :string(255)
#  participation_type               :string(255)
#  created_at                       :datetime
#  updated_at                       :datetime
#  signup_ip                        :string(255)
#  signup_at                        :datetime
#  voted                            :string(255)
#  called_311                       :string(255)
#  secondary_connection_id          :integer
#  secondary_connection_description :string(255)
#  verified                         :string(255)
#  preferred_contact_method         :string(255)
#  token                            :string(255)
#  active                           :boolean          default(TRUE)
#  deactivated_at                   :datetime
#  deactivated_method               :string(255)
#  neighborhood                     :string(255)
#  tag_count_cache                  :integer          default(0)
#

# FIXME: Refactor and re-enable cop
# rubocop:disable ClassLength
class Person < ActiveRecord::Base
  has_paper_trail

  # include Searchable
  include ExternalDataMappings
  include Neighborhoods

  phony_normalize :phone_number, default_country_code: 'US'
  phony_normalized_method :phone_number, default_country_code: 'US'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :submissions, dependent: :destroy

  has_many :gift_cards
  accepts_nested_attributes_for :gift_cards, reject_if: :all_blank
  attr_accessor :gift_cards_attributes

  has_many :reservations, dependent: :destroy
  has_many :events, through: :reservations

  has_many :tags, through: :taggings
  has_many :taggings, as: :taggable

  # we don't really need a join model, exceptionally HABTM is more appropriate
  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :event_invitations, class_name: '::V2::EventInvitation', join_table: :invitation_invitees_join_table
  # rubocop:enable Rails/HasAndBelongsToMany

  has_many :v2_reservations, class_name: '::V2::Reservation'
  has_many :v2_events, through: :event_invitations, foreign_key: 'v2_event_id', source: :event

  has_secure_token :token

  after_update  :sendToMailChimp
  after_create  :sendToMailChimp
  after_create  :update_neighborhood

  validates :first_name, presence: true
  validates :last_name, presence: true

  # if ENV['BLUE_RIDGE'].nil?
  #   validates :primary_device_id, presence: true
  #   validates :primary_device_description, presence: true
  #   validates :primary_connection_id, presence: true
  #   validates :primary_connection_description, presence: true
  # end

  validates :postal_code, presence: true
  validates :postal_code, zipcode: { country_code: :us }

  # phony validations and normalization
  phony_normalize :phone_number, default_country_code: 'US'

  validates :phone_number, presence: true, length: { in: 9..15 },
    unless: proc { |person| person.email_address.present? }
  # validates :phone_number, allow_blank: true, uniqueness: true

  validates :email_address, presence: true,
    unless: proc { |person| person.phone_number.present? }
  # validates :email_address, email: true, allow_blank: true, uniqueness: true

  scope :no_signup_card, -> { where('id NOT IN (SELECT DISTINCT(person_id) FROM gift_cards where gift_cards.reason = 1)') }
  scope :signup_card_needed, -> { joins(:gift_cards).where('gift_cards.reason !=1') }

  self.per_page = 15

  ransacker :full_name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('lower',
      [Arel::Nodes::NamedFunction.new('concat_ws',
        [Arel::Nodes.build_quoted(' '), parent.table[:first_name], parent.table[:last_name]])])
  end

  def self.ransackable_scopes(auth_object = nil)
    %i(no_signup_card)
  end

  ransack_alias :nav_bar_search, :full_name_or_email_address_or_phone_number

  def signup_gc_sent
    signup_cards = gift_cards.where(reason: 1)
    return true unless signup_cards.empty?
    false
  end

  def gift_card_total
    total = gift_cards.sum(:amount_cents)
    Money.new(total, 'USD')
  end

  WUFOO_FIELD_MAPPING = {
    'Field1'   => :first_name,
    'Field2'   => :last_name,
    'Field10'  => :email_address,
    'Field276' => :voted,
    'Field277' => :called_311,
    'Field39'  => :primary_device_id, # type of primary
    'Field21'  => :primary_device_description, # desc of primary
    'Field40'  => :secondary_device_id,
    'Field24'  => :secondary_device_description, # desc of secondary
    'Field41'  => :primary_connection_id, # connection type
    # 'Field41' =>  :primary_connection_description, # description of connection
    'Field42'  => :secondary_connection_id, # connection type
    # 'Field42' =>  :secondary_connection_description, # description of connection
    'Field268' => :address_1, # address_1
    'Field269' => :city, # city
    # 'Field47' =>  :state, # state
    'Field271' => :postal_code, # postal_code
    'Field9'   => :phone_number, # phone_number
    'IP'       => :signup_ip, # client IP, ignored for the moment

  }.freeze

  def tag_values
    tags.collect(&:name)
  end

  def tag_count
    tags.size
  end

  def submission_values
    submissions.collect(&:submission_values)
  end

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Rails/TimeZone
  #
  def self.initialize_from_wufoo_sms(params)
    new_person = Person.new

    # Save to Person
    new_person.first_name = params['Field275']
    new_person.last_name = params['Field276']
    new_person.address_1 = params['Field268']
    new_person.postal_code = params['Field271']
    new_person.email_address = params['Field279']
    new_person.phone_number = params['field281']
    new_person.primary_device_id = case params['Field39'].upcase
                                   when 'A'
                                     Person.map_device_to_id('Desktop computer')
                                   when 'B'
                                     Person.map_device_to_id('Laptop')
                                   when 'C'
                                     Person.map_device_to_id('Tablet')
                                   when 'D'
                                     Person.map_device_to_id('Smart phone')
                                   else
                                     params['Field39']
                                   end

    new_person.primary_device_description = params['Field21']

    new_person.primary_connection_id = case params['Field41'].upcase
                                       when 'A'
                                         Person.primary_connection_id('Broadband at home')
                                       when 'B'
                                         Person.primary_connection_id('Phone plan with data')
                                       when 'C'
                                         Person.primary_connection_id('Public wi-fi')
                                       when 'D'
                                         Person.primary_connection_id('Public computer center')
                                       else
                                         params['Field41']
                                       end

    new_person.preferred_contact_method = if params['Field278'].casecmp('TEXT')
                                            'SMS'
                                          else
                                            'EMAIL'
                                          end

    new_person.verified = 'Verified by Text Message Signup'
    new_person.signup_at = Time.now

    new_person
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Rails/TimeZone

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Style/MethodName, Metrics/BlockNesting, Style/VariableName, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  #
  def sendToMailChimp
    if email_address.present?
      if verified.present?
        if verified.start_with?('Verified')
          begin

            gibbon = Gibbon::Request.new
            mailchimpSend = gibbon.lists(Logan::Application.config.cut_group_mailchimp_list_id).members(Digest::MD5.hexdigest(email_address.downcase)).upsert(
              body: { email_address: email_address.downcase,
                      status: 'subscribed',
                      merge_fields: { FNAME: first_name || '',
                                      LNAME: last_name || '',
                                      MMERGE3: geography_id || '',
                                      MMERGE4: postal_code || '',
                                      MMERGE5: participation_type || '',
                                      MMERGE6: voted || '',
                                      MMERGE7: called_311 || '',
                                      MMERGE8: primary_device_description || '',
                                      MMERGE9: secondary_device_id || '',
                                      MMERGE10: secondary_device_description || '',
                                      MMERGE11: primary_connection_id || '',
                                      MMERGE12: primary_connection_description || '',
                                      MMERGE13: primary_device_id || '',
                                      MMERGE14: preferred_contact_method || '' } }
            )

            Rails.logger.info("[People->sendToMailChimp] Sent #{id} to Mailchimp: #{mailchimpSend}")
          rescue Gibbon::MailChimpError => e
            Rails.logger.fatal("[People->sendToMailChimp] fatal error sending #{id} to Mailchimp: #{e.message}")
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Style/MethodName, Metrics/BlockNesting, Style/VariableName, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Rails/TimeZone, Metrics/PerceivedComplexity
  #
  def self.initialize_from_wufoo(params)
    new_person = Person.new
    params.each_pair do |k, v|
      new_person[WUFOO_FIELD_MAPPING[k]] = v if WUFOO_FIELD_MAPPING[k].present?
    end

    # Special handling of participation type. New form uses 2 fields where old form used 1. Need to combine into one. Manually set to "Either one" if both field53 & field54 are populated.
    new_person.participation_type = if params['Field53'] != '' && params['Field54'] != ''
                                      'Either one'
                                    elsif params['Field53'] != ''
                                      params['Field53']
                                    else
                                      params['Field54']
                                    end

    new_person.preferred_contact_method = if params['Field273'] == 'Email'
                                            'EMAIL'
                                          else
                                            'SMS'
                                          end

    # Copy connection descriptions to description fields
    new_person.primary_connection_description = new_person.primary_connection_id
    new_person.secondary_connection_description = new_person.secondary_connection_id

    # rewrite the device and connection identifiers to integers
    new_person.primary_device_id        = Person.map_device_to_id(params[WUFOO_FIELD_MAPPING.rassoc(:primary_device_id).first])
    new_person.secondary_device_id      = Person.map_device_to_id(params[WUFOO_FIELD_MAPPING.rassoc(:secondary_device_id).first])
    new_person.primary_connection_id    = Person.map_connection_to_id(params[WUFOO_FIELD_MAPPING.rassoc(:primary_connection_id).first])
    new_person.secondary_connection_id  = Person.map_connection_to_id(params[WUFOO_FIELD_MAPPING.rassoc(:secondary_connection_id).first])

    # FIXME: this is a hack, since we need to initialize people
    # with a city/state, but don't ask for it in the Wufoo form
    # new_person.city  = "Chicago" With update we ask for city
    new_person.state = 'Illinois'

    new_person.signup_at = params['DateCreated']

    new_person
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Rails/TimeZone, Metrics/PerceivedComplexity

  def primary_device_type_name
    if primary_device_id.present?
      Logan::Application.config.device_mappings.rassoc(primary_device_id)[0].to_s
    end
  end

  def secondary_device_type_name
    if secondary_device_id.present?
      Logan::Application.config.device_mappings.rassoc(secondary_device_id)[0].to_s
    end
  end

  def primary_connection_type_name
    if primary_connection_id.present?
      Logan::Application.config.connection_mappings.rassoc(primary_connection_id)[0].to_s
    end
  end

  def secondary_connection_type_name
    if secondary_connection_id.present?
      Logan::Application.config.connection_mappings.rassoc(secondary_connection_id)[0].to_s
    end
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def address_fields_to_sentence
    [address_1, address_2, city, state, postal_code].reject(&:blank?).join(', ')
  end

  def self.send_all_reminders
    # this is where reservation_reminders
    # called by whenever in /config/schedule.rb
    Person.all.find_each(&:send_reservation_reminder)
  end

  def send_reservation_reminder
    return if v2_reservations.for_today_and_tomorrow.size.zero?
    case preferred_contact_method.upcase
    when 'SMS'
      ::ReservationReminderSms.new(to: self, reservations: v2_reservations.for_today_and_tomorrow).send
    when 'EMAIL'
      ReservationNotifier.remind(
        reservations:  v2_reservations.for_today_and_tomorrow.to_a,
        email_address: email_address
      ).deliver_later
    end
  end

  def deactivate!(method = nil)
    self.active = false
    self.deactivated_at = Time.current
    self.deactivated_method = method if method
    save!
  end

  def update_neighborhood
    n = zip_to_neighborhood(postal_code)
    unless n.blank?
      self.neighborhood = n
      save
    end
  end

  # Compare to other records in the database to find possible duplicates.
  def possible_duplicates
    @duplicates = {}
    if last_name.present?
      last_name_duplicates = Person.where(last_name: last_name).where.not(id: id)
      last_name_duplicates.each do |duplicate|
        duplicate_hash = {}
        duplicate_hash['person'] = duplicate
        duplicate_hash['match_count'] = 1
        duplicate_hash['last_name_match'] = true
        duplicate_hash['matches_on'] = ['Last Name']
        @duplicates[duplicate.id] = duplicate_hash
      end
    end
    if email_address.present?
      email_address_duplicates = Person.where(email_address: email_address).where.not(id: id)
      email_address_duplicates.each do |duplicate|
        if @duplicates.key? duplicate.id
          @duplicates[duplicate.id]['match_count'] += 1
          @duplicates[duplicate.id]['matches_on'].push('Email Address')
        else
          @duplicates[duplicate.id] = {}
          @duplicates[duplicate.id]['person'] = duplicate
          @duplicates[duplicate.id]['match_count'] = 1
          @duplicates[duplicate.id]['matches_on'] = ['Email Address']
        end
        @duplicates[duplicate.id]['email_address_match'] = true
      end
    end
    if phone_number.present?
      phone_number_duplicates = Person.where(phone_number: phone_number).where.not(id: id)
      phone_number_duplicates.each do |duplicate|
        if @duplicates.key? duplicate.id
          @duplicates[duplicate.id]['match_count'] += 1
          @duplicates[duplicate.id]['matches_on'].push('Phone Number')
        else
          @duplicates[duplicate.id] = {}
          @duplicates[duplicate.id]['person'] = duplicate
          @duplicates[duplicate.id]['match_count'] = 1
          @duplicates[duplicate.id]['matches_on'] = ['Phone Number']
        end
        @duplicates[duplicate.id]['phone_number_match'] = true
      end
    end
    if address_1.present?
      address_1_duplicates = Person.where(address_1: address_1).where.not(id: id)
      address_1_duplicates.each do |duplicate|
        if @duplicates.key? duplicate.id
          @duplicates[duplicate.id]['match_count'] += 1
          @duplicates[duplicate.id]['matches_on'].push('Address_1')
        else
          @duplicates[duplicate.id] = {}
          @duplicates[duplicate.id]['person'] = duplicate
          @duplicates[duplicate.id]['match_count'] = 1
          @duplicates[duplicate.id]['matches_on'] = ['Address_1']
        end
        @duplicates[duplicate.id]['address_1_match'] = true
      end
    end
    @duplicates
  end

end
# rubocop:enable ClassLength
