require 'rails_helper'

RSpec.describe '/shifts', type: :request do
  let(:valid_attributes) {
    skip('Add a hash of attributes valid for your model')
  }

  let(:invalid_attributes) {
    skip('Add a hash of attributes invalid for your model')
  }

  let(:valid_headers) {
    {}
  }

  describe 'GET /index' do
    it 'renders a successful response' do
      Shift.create! valid_attributes
      get api_shifts_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      shift = Shift.create! valid_attributes
      get api_shift_url(shift), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Shift' do
        expect {
          post api_shifts_url,
               params: { shift: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Shift, :count).by(1)
      end

      it 'renders a JSON response with the new shift' do
        post api_shifts_url,
             params: { shift: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Shift' do
        expect {
          post api_shifts_url,
               params: { shift: invalid_attributes }, as: :json
        }.to change(Shift, :count).by(0)
      end

      it 'renders a JSON response with errors for the new shift' do
        post api_shifts_url,
             params: { shift: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested shift' do
        shift = Shift.create! valid_attributes
        patch api_shift_url(shift),
              params: { shift: invalid_attributes }, headers: valid_headers, as: :json
        shift.reload
        skip('Add assertions for updated state')
      end

      it 'renders a JSON response with the shift' do
        shift = Shift.create! valid_attributes
        patch api_shift_url(shift),
              params: { shift: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the shift' do
        shift = Shift.create! valid_attributes
        patch api_shift_url(shift),
              params: { shift: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'rejects the request' do
      shift = Shift.create! valid_attributes
      expect {
        delete api_shift_url(shift), headers: valid_headers, as: :json
      }.to change(Shift, :count).by(-1)
    end
  end
end
