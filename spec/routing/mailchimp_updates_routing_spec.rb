# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MailchimpUpdatesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/mailchimp_updates').to route_to('mailchimp_updates#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/mailchimp_updates/new').to route_to('mailchimp_updates#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/mailchimp_updates/1').to route_to('mailchimp_updates#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/mailchimp_updates/1/edit').to route_to('mailchimp_updates#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/mailchimp_updates').to route_to('mailchimp_updates#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/mailchimp_updates/1').to route_to('mailchimp_updates#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/mailchimp_updates/1').to route_to('mailchimp_updates#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/mailchimp_updates/1').to route_to('mailchimp_updates#destroy', id: '1')
    end
  end
end
