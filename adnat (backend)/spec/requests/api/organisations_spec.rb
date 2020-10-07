require 'rails_helper'

RSpec.describe '/organisations', type: :request do
  let(:frozen_time) { Time.now }
  let(:valid_headers) { {} }

  let(:valid_attributes) do
    {
      :name => "Bob's Burgers",
      :hourly_rate => 16.25
    }
  end

  let(:invalid_attributes) do
    {
      :name => "Bob's Burgers",
      :hourly_rate => '$16.25'
    }
  end

  before { Timecop.freeze(frozen_time) }

  after { Timecop.return }

  describe 'GET #index' do
    # TODO: must be authenticated and authorized
    let!(:organisation) { Organisation.create!(valid_attributes) }
    let(:expected_response) { [organisation].to_json }

    before do
      get api_organisations_url, headers: valid_headers, as: :json
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'includes in the response body a list of all Organisations' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'GET #show' do
    # TODO: must be authenticated and authorized
    let!(:organisation) { Organisation.create!(valid_attributes) }

    before { get api_organisation_url(organisation), as: :json }

    it 'renders a successful JSON response containing the details of the requested Organisation' do
      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including('application/json'))
      expect(response.body).to eq(organisation.to_json)
    end
  end

  describe 'POST #create' do
    # TODO: must be authenticated and authorized
    def make_request
      post api_organisations_url,
           params: { organisation: attributes },
           headers: valid_headers,
           as: :json
    end

    context 'with valid parameters' do
      let(:attributes) { valid_attributes }

      it 'creates a new Organisation' do
        expect {make_request}.to change(Organisation, :count).by(1)
      end

      it 'renders a successful JSON response containing the details of the requested Organisation' do
        make_request
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(response.body).to eq(Organisation.find(1).to_json)
      end
    end

    context 'with invalid parameters' do
      let(:attributes) { invalid_attributes }

      let(:expected_error_message) do
        "Invalid parameter 'hourly_rate' value \"$16.25\": Must be a Float"
      end

      it 'does not create a new Organisation' do
        expect {make_request}.to change(Organisation, :count).by(0)
      end

      it 'renders a JSON response with errors for the new Organisation' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body)).to eq({ 'message' => expected_error_message })
      end
    end
  end

  describe 'PATCH #update' do
    # TODO: must be authenticated and authorized
    def make_request
      patch api_organisation_url(organisation),
            params: { organisation: new_attributes },
            headers: valid_headers,
            as: :json
    end

    let!(:organisation) { Organisation.create!(valid_attributes) }

    context 'with valid parameters' do
      let(:new_attributes) { { 'hourly_rate' => 10.0 } }

      it 'updates the requested Organisation' do
        make_request
        organisation.reload
        expect(organisation[new_attributes.keys.first]).to eq(new_attributes.values.first)
      end

      it 'updates the requested Organisation and renders a successful JSON response containing the details of the requested Organisation' do
        make_request
        organisation.reload
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body)).to eq(organisation.as_json)
      end
    end

    context 'with invalid parameters' do
      let(:new_attributes) { { 'hourly_rate' => 'Invalid Input' } }

      let(:expected_error_message) do
        "Invalid parameter 'hourly_rate' value \"Invalid Input\": Must be a Float"
      end

      it 'does not update the requested Organisation' do
        make_request
        organisation.reload
        expect(organisation[new_attributes.keys.first]).not_to eq(new_attributes.values.first)
      end

      it 'updates the requested Organisation and renders a successful JSON response containing the details of the requested Organisation' do
        make_request
        organisation.reload
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body)).to eq({ 'message' => expected_error_message })
      end
    end
  end

  describe 'GET #index_associated_users' do
    # TODO: must be authenticated and authorized
    let!(:user) { User.create!(user_attributes) }
    let!(:organisation) { Organisation.create!(valid_attributes) }

    let(:expected_response) { [user].to_json }

    let(:user_attributes) do
      {
        'first_name' => 'Bob',
        'last_name' => 'Washington',
        'email_address' => 'bwash@bobsburgers.com',
        'password' => 'password1',
        'password_confirmation' => 'password1'
      }
    end

    before do
      OrganisationsUser.create!(organisation: organisation, user: user)
      get api_organisation_users_url(organisation), headers: valid_headers, as: :json
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'includes in the response body a list of all Users associated with the specified Organisation' do
      expect(response.body).to eq(expected_response)
    end
  end
end
