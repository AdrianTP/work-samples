require 'rails_helper'

RSpec.describe Api::ShiftsController, type: :routing do
  describe 'routing' do
    it 'routes to #index gia GET' do
      expect(get: '/api/shifts').to route_to('api/shifts#index')
    end

    it 'routes to #show via GET with id' do
      expect(get: '/api/shifts/1').to route_to('api/shifts#show', id: '1')
    end

    it 'routes to #index for user via GET with id' do
      expect(get: '/api/users/1/shifts').to route_to('api/shifts#index_for_user', user_id: '1')
    end

    it 'routes to #create_for_user via POST with id' do
      expect(post: '/api/users/1/shifts').to route_to('api/shifts#create_for_user', user_id: '1')
    end

    it 'routes to #update via PUT with id' do
      expect(put: '/api/shifts/1').to route_to('api/shifts#update', id: '1')
    end

    it 'routes to #update via PATCH with id' do
      expect(patch: '/api/shifts/1').to route_to('api/shifts#update', id: '1')
    end

    it 'routes to #destroy via DELETE with id' do
      expect(delete: '/api/shifts/1').to route_to('api/shifts#destroy', id: '1')
    end
  end
end
