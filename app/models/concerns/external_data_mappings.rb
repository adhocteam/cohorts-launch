# frozen_string_literal: true
require 'active_support/concern'

module ExternalDataMappings

  extend ActiveSupport::Concern

  module ClassMethods
    def map_connection_to_id(val)
      sym = case val
            when 'Broadband at home (cable, DSL, etc.)', 'Home broadband (cable, DSL)'
              :home_broadband
            when 'Public computer'
              :public_computer
            when 'Phone with data plan'
              :phone
            when 'Public wi-fi', 'Public Wi-Fi'
              :public_wifi
            else
              :other
            end

      Cohorts::Application.config.connection_mappings[sym]
    end

    def map_device_to_id(val)
      sym = case val
            when 'Laptop', 'Laptop Computer'
              :laptop
            when 'Smartphone', 'Smartphone (e.g. iPhone or Android phone)'
              :smartphone
            when 'Desktop', 'Desktop Computer'
              :desktop
            when 'Tablet', 'Tablet (e.g. iPad)'
              :tablet
            end

      ret = Cohorts::Application.config.device_mappings[sym]
      Rails.logger.debug "[map_device_to_id] given <<#{val}>> returning <<#{ret}>>"
      ret
    end
  end

end
