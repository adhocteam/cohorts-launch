# frozen_string_literal: true
require 'csv'
# rubocop:disable ClassLength, Metrics/BlockLength, Metrics/AbcSize
class SearchController < ApplicationController

  include PeopleHelper
  include GsmHelper

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def index
    @q = Person.ransack(params[:q])
    @results = @q.result(distinct: true).includes(:tags, :questions, :answers).page(params[:page])
    @tags = params[:tags_id_eq_any].blank? ? '[]' : Tag.where(name: params[:tags_id_eq_any].split(',').map(&:strip)).to_json(methods: [:value, :label, :type])
    @tag_list = Tag.order(:name)
    @question_list = Question.order(:text)
    @participation_list = Person.uniq.pluck(:participation_type) # Need to better define these
    @verified_list = Person.uniq.pluck(:verified)
    @mailchimp_result = 'Mailchimp export not attempted with this search'

    respond_to do |format|
      format.json { @results.map { |r| r['type'] = 'person' }.to_json }
      format.html do
        if params[:segment_name].present?
          list_name = params.delete(:segment_name)
          @q = Person.ransack(params[:q])
          @results_mailchimp = @q.result(distinct: true).includes(:tags, :questions, :answers)
          @mce = MailchimpExport.new(name: list_name, recipients: @results_mailchimp.collect(&:email_address), created_by: current_user.id)
          if @mce.with_user(current_user).save
            Rails.logger.info("[SearchController#export] Sent #{@mce.recipients.size} email addresses to a static segment named #{@mce.name}")
            @success = "Sent #{@mce.recipients.size} email addresses to a static segment named #{@mce.name}"
            flash[:success] = "Successfully sent to mailchimp: #{@mce.errors.inspect}"
          else
            Rails.logger.error("[SearchController#export] failed to send event to mailchimp: #{@mce.errors.inspect}")
            @error = "failed to send search to mailchimp: #{@mce.errors.inspect}"
            flash[:failure] = "failed to send search to mailchimp: #{@mce.errors.inspect}"
          end
        end
      end
      format.csv do
        @results = @q.result(distinct: true).includes(:tags, :questions, :answers)
        fields = Person.column_names
        fields.push('tags')
        if index_params[:submissions]
          @submissions = index_params[:submissions].reject(&:empty?)
          @questions = Submission.select { |submission| @submissions.include? submission.form_name }.map(&:questions).flatten.uniq
          @questions.each { |q| fields.push(q.text) }
        end
        output = CSV.generate do |csv|
          # Generate the headers
          csv << fields.map(&:titleize)

          # Some fields need a helper method
          human_devices = %w(primary_device_id secondary_device_id)
          human_connections = %w(primary_connection_id secondary_connection_id)

          # Write the results
          @results.each do |person|
            csv << fields.map do |f|
              field_value = person[f]
              if human_devices.include? f
                human_device_type_name(field_value)
              elsif human_connections.include? f
                human_connection_type_name(field_value)
              elsif f == 'phone_number'
                if field_value.present?
                  field_value.phony_formatted(format: :national, spaces: '-')
                else
                  ''
                end
              elsif f == 'tags'
                if person.tag_values.blank?
                  ''
                else
                  person.tag_values.join('|')
                end
              elsif @questions&.map(&:text).include? f
                q = @questions.find { |question| question.text == f }
                person.answers.find_by(question: q)&.value
              else
                field_value
              end
            end
          end
        end
        send_data output, type: 'text/csv', filename: "Search-#{Time.zone.today}.csv"
      end
    end
  end

  def save_to_engagement
    @engagement = Engagement.find(engagement_params[:id])
    @engagement.search_query = params[:engagement][:search_query]
    respond_to do |format|
      format.js {}
    end
  end

  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def export_ransack
    list_name = params.delete(:segment_name)
    @q = Person.ransack(params[:q])
    @results = @q.result.includes(:tags)
    @mce = MailchimpExport.new(name: list_name, recipients: @results.collect(&:email_address), created_by: current_user.id)
    if @mce.with_user(current_user).save
      Rails.logger.info("[SearchController#export] Sent #{@mce.recipients.size} email addresses to a static segment named #{@mce.name}")
      respond_to do |format|
        format.js {}
      end
    else
      Rails.logger.error("[SearchController#export] failed to send event to mailchimp: #{@mce.errors.inspect}")
      format.all { render text: "failed to send event to mailchimp: #{@mce.errors.inspect}", status: 400 }
    end
  end

  def export
    # send all results to a new static segment in mailchimp
    list_name = params.delete(:segment_name)
    @q = Person.ransack(params[:q])
    @people = @q.result.includes(:tags)
    @mce = MailchimpExport.new(name: list_name, recipients: @people.collect(&:email_address), created_by: current_user.id)

    if @mce.with_user(current_user).save
      Rails.logger.info("[SearchController#export] Sent #{@mce.recipients.size} email addresses to a static segment named #{@mce.name}")
      respond_to do |format|
        format.js {}
      end
    else
      Rails.logger.error("[SearchController#export] failed to send event to mailchimp: #{@mce.errors.inspect}")
      format.all { render text: "failed to send event to mailchimp: #{@mce.errors.inspect}", status: 400 }
    end
  end

  # FIXME: Refactor and re-enable cop
  # rubocop:disable Metrics/MethodLength, Style/MethodName, Style/VariableName
  #
  def exportTwilio
    # send messages to all people
    message1 = params.delete(:message1)
    message2 = params.delete(:message2)
    message1 = to_gsm0338(message1)
    message2 = to_gsm0338(message2) if message2.present?
    messages = Array[message1, message2]
    smsCampaign = params.delete(:twiliowufoo_campaign)
    @q = Person.ransack(params[:q])
    @people = @q.result.includes(:tags)
    Rails.logger.info("[SearchController#exportTwilio] people #{@people}")
    phone_numbers = @people.collect(&:phone_number)
    Rails.logger.info("[SearchController#exportTwilio] people #{phone_numbers}")
    phone_numbers = phone_numbers.reject { |e| e.to_s.blank? }
    @job_enqueue = Delayed::Job.enqueue SendTwilioMessagesJob.new(messages, phone_numbers, smsCampaign)
    if @job_enqueue.save
      Rails.logger.info("[SearchController#exportTwilio] Sent #{phone_numbers} to Twilio")
      respond_to do |format|
        format.js {}
      end
    else
      Rails.logger.error('[SearchController#exportTwilio] failed to send text messages')
      format.all { render text: 'failed to send text messages', status: 400 }
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Style/MethodName, Style/VariableName

  private

    # lotta params...
    # rubocop:disable Metrics/MethodLength,
    def index_params
      params.permit(:q,
        :adv,
        :active,
        :first_name,
        :last_name,
        :email_address,
        :postal_code,
        :phone_number,
        :verified,
        :device_description,
        :connection_description,
        :device_id_type,
        :connection_id_type,
        :geography_id,
        :event_id,
        :address,
        :city,
        :submissions,
        :tags,
        :preferred_contact_method,
        :page,
        :engagement_id,
        submissions: [])
    end
    # rubocop:enable Metrics/MethodLength

    def engagement_params
      params.require(:engagement).permit(:id)
    end
end
# rubocop:enable ClassLength
