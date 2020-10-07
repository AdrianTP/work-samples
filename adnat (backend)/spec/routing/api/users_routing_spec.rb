require 'rails_helper'

RSpec.describe Api::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index via GET' do
      expect(get: '/api/users').to route_to('api/users#index')
    end

    it 'routes to #show via GET with id' do
      expect(get: '/api/users/1').to route_to('api/users#show', id: '1')
    end


    it 'routes to #create via POST' do
      expect(post: '/api/users').to route_to('api/users#create')
    end

    it 'routes to #update via PUT with id' do
      expect(put: '/api/users/1').to route_to('api/users#update', id: '1')
    end

    it 'routes to #update via PATCH with id' do
      expect(patch: '/api/users/1').to route_to('api/users#update', id: '1')
    end

    it 'routes to #destroy via DELETE with id' do
      expect(delete: '/api/users/1').to route_to('api/users#destroy', id: '1')
    end

    it 'routes to #index_associated_organisations via GET with user_id' do
      expect(get: '/api/users/1/organisations').to route_to('api/users#index_associated_organisations', user_id: '1')
    end

    it 'routes to #join_organisation via POST with organisation_id and user_id' do
      expect(post: '/api/users/1/organisations/1').to route_to('api/users#join_organisation', organisation_id: '1', user_id: '1')
    end

    it 'routes to #leave_organisation via DELETE with organisation_id and user_id' do
      expect(delete: '/api/users/1/organisations/1').to route_to('api/users#leave_organisation', organisation_id: '1', user_id: '1')
    end
  end
end
