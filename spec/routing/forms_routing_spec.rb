# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FormsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/forms').to route_to('forms#index')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/forms/1').to route_to('forms#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/forms/1').to route_to('forms#update', id: '1')
    end
  end
end
