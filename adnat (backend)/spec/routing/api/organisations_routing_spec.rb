require 'rails_helper'

RSpec.describe Api::OrganisationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index via GET' do
      expect(get: '/api/organisations').to route_to('api/organisations#index')
    end

    it 'routes to #show via GET with id' do
      expect(get: '/api/organisations/1').to route_to('api/organisations#show', id: '1')
    end

    it 'routes to #create via POST' do
      expect(post: '/api/organisations').to route_to('api/organisations#create')
    end

    it 'routes to #update via PUT with id' do
      expect(put: '/api/organisations/1').to route_to('api/organisations#update', id: '1')
    end

    it 'routes to #update via PATCH with id' do
      expect(patch: '/api/organisations/1').to route_to('api/organisations#update', id: '1')
    end

    it 'routes to #index_associated_users via GET with organisation_id' do
      expect(get: '/api/organisations/1/users').to route_to('api/organisations#index_associated_users', organisation_id: '1')
    end

    it 'does not route to #destroy via DELETE with id' do
      expect(delete: '/api/organisations/1').not_to be_routable
    end
  end
end
