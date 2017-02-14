# frozen_string_literal: true
require 'active_support/concern'
require 'elasticsearch/model'
require 'elasticsearch/dsl'
# rubocop:disable Metrics/BlockLength
module Searchable

  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # namespace indices
    index_name "person-#{Rails.env}"

    settings analysis: {
      analyzer: {
        email_analyzer: {
          tokenizer: 'uax_url_email',
          filter: ['lowercase'],
          type: 'custom'
        }
      }
    } do
      mappings dynamic: 'false' do
        indexes :id, index: :not_analyzed
        indexes :first_name, analyzer: :snowball
        indexes :last_name, analyzer: :snowball
        indexes :email_address, analyzer: 'email_analyzer'
        indexes :phone_number, index: :not_analyzed
        indexes :postal_code, index: :not_analyzed
        indexes :geography_id, index: :not_analyzed
        indexes :address_1 # FIXME: if we ever use address_2, this will not work
        indexes :city
        indexes :verified, analyzer: :snowball
        indexes :active

        # device types
        indexes :primary_device_type_name, analyzer: :snowball
        indexes :secondary_device_type_name, analyzer: :snowball

        indexes :primary_device_id
        indexes :secondary_device_id

        # device descriptions
        indexes :primary_device_description
        indexes :secondary_device_description
        indexes :primary_connection_description
        indexes :secondary_connection_description

        # comments
        indexes :comments do
          indexes :content, analyzer: :snowball
        end

        # submissions
        # indexes the output of the Submission#indexable_values method
        indexes :submission_values, analyzer: :snowball

        # tags
        indexes :tag_values, analyzer: :keyword

        indexes :preferred_contact_method

        indexes :created_at, type: 'date'
      end
    end
  end

  module ClassMethods

    # FIXME: Refactor and re-enable cop
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    #
    def complex_search(params, per_page)
      options = {}

      options[:per_page] = per_page
      options[:page]     = params[:page] || 1

      params.delete(:adv)
      params.delete(:page)
      params[:active] = true

      params[:phone_number].delete!('^0-9') unless params[:phone_number].blank?

      unless params[:device_id_type].blank?
        device_id_string = params[:device_id_type].join(' ')
      end

      unless params[:connection_id_type].blank?
        connection_id_string = params[:connection_id_type].join(' ')
      end

      query = Elasticsearch::DSL::Search.search do
        query do
          bool do
            params.each do |k, v|
              # all of this is a bit bananas.
              # looking forard to new elastic search gem
              next if v.blank? || k == :adv

              case k.to_sym
              when :connection_description
                must do
                  _or do
                    match primary_connection_description: v
                    match secondary_connection_description: v
                  end
                end
              when :device_description
                must do
                  _or do
                    match primary_device_description: v
                    match secondary_device_description: v
                  end
                end
              when :device_id_type
                must do
                  _or do
                    match primary_device_id: device_id_string
                    match secondary_device_id: device_id_string
                  end
                end
              when :tags
                must { match tag_values: v }
              when :submissions
                must { match submission_values: v }
              when :connection_id_type
                must do
                  _or do
                    match primary_connection_id: connection_id_string
                    match secondary_connection_id: connection_id_string
                  end
                end
              when :address
                must { match address_1: v }
              else # no more special cases.
                must { match Hash[k, v] }
              end
            end
          end
        end
        # filter :terms, tag_values: params[:tags] if params[:tags].present?
      end
      Person.__elasticsearch__.search(query)
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  end

  def to_indexed_json
    # customize what data is sent to ES for indexing
    to_json(
      methods: [:tag_values, :submission_values],
      include: {
        comments: {
          only: [:content]
        }
      }
    )
  end

end
