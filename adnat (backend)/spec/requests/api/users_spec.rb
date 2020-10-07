require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:frozen_time) { Time.now }
  let(:valid_headers) { {} }

  let(:valid_attributes_any) do
    {
      :first_name => "Bob",
      :last_name => "Washington",
      :email_address => "bob.washington@gmail.com"
    }
  end

  let(:valid_attributes_update_delete) do
    valid_attributes_any.merge({
      :password => 'password123'
    })
  end

  let(:invalid_attributes_update_delete) do
    valid_attributes_any.merge({
      :password => 'wrongpassword'
    })
  end

  let(:valid_attributes_create) do
    valid_attributes_update_delete.merge({
      :password_confirmation => 'password123'
    })
  end

  let(:invalid_attributes_create) do
    valid_attributes_create.merge({
      :password_confirmation => 'notmatching'
    })
  end

  before { Timecop.freeze(frozen_time) }

  after { Timecop.return }

  describe 'GET #index' do
    # TODO: must be authenticated and authorized
    let!(:user) { User.create!(valid_attributes_create) }
    let(:expected_response) { [user].to_json }

    before do
      get api_users_url, headers: valid_headers, as: :json
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'includes in the response body a list of all Users' do
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'GET #show' do
    # TODO: must be authenticated and authorized
    let!(:user) { User.create!(valid_attributes_create) }

    before { get api_user_url(user), as: :json }

    it 'renders a successful JSON response containing the details of the requested User' do
      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including('application/json'))
      expect(response.body).to eq(user.to_json)
    end
  end

  describe 'POST #create' do
    # TODO: must NOT be authenticated and authorized
    # TODO: requires all fields including :password and :password_confirmation
    def make_request
      post api_users_url,
           params: { user: attributes },
           headers: valid_headers,
           as: :json
    end

    context 'with valid parameters' do
      let(:attributes) { valid_attributes_create }

      it 'creates a new User' do
        expect {make_request}.to change(User, :count).by(1)
      end

      it 'renders a successful JSON response containing the details of the requested User' do
        make_request
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(response.body).to eq(User.find(1).to_json)
      end
    end

    context 'with invalid parameters' do
      let(:attributes) { invalid_attributes_create }

      let(:expected_error_message) do
        ""
      end

      it 'does not create a new User' do
        expect {make_request}.to change(User, :count).by(0)
      end

      it 'renders a JSON response with errors for the new User' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
        expect(JSON.parse(response.body)).to eq({ 'message' => expected_error_message })
      end
    end
  end

  describe 'PATCH #update' do
    # TODO: must be authenticated and authorized
    # TODO: may include :current_password, :new_password, and :new_password_confirmation
    context 'with valid parameters' do
      let(:new_attributes) {
        skip('Add a hash of attributes valid for your model')
      }

      it 'updates the requested user' do
        user = User.create! valid_attributes
        patch api_user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
        user.reload
        skip('Add assertions for updated state')
      end

      it 'renders a JSON response with the user' do
        user = User.create! valid_attributes
        patch api_user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the user' do
        user = User.create! valid_attributes
        patch api_user_url(user),
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    # TODO: must be authenticated and authorized
    # TODO: must include :current_password
    it 'rejects the request' do
      user = User.create! valid_attributes
      expect {
        delete api_user_url(user), headers: valid_headers, as: :json
      }.to change(User, :count).by(-1)
    end
  end

  describe 'GET #index_associated_organisations' do
  end

  describe 'POST #join_organisation' do
  end

  describe 'DELETE #leave_organisation' do
  end
end
