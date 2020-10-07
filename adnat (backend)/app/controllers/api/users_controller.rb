class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  # skip_before_action :authenticate_user, only: [:create]

  def_param_group :user_fields do
    param :first_name, String, :required => true, :desc => 'Given name'
    param :last_name, String, :required => true, :desc => 'Family name'
    param :email_address, String, :required => true, :desc => 'Email address'
  end

  def_param_group :user_password do
    param :user, Hash, :action_aware => true do
      param :password, String, :required => true, :desc => 'Password'
    end
  end

  def_param_group :user_password_confirmation do
    param :user, Hash, :action_aware => true do
      param :password_confirmation, String, :required => true, :desc => 'Must match Password'
    end
  end

  def_param_group :user_password_check do
    param :user, Hash, :action_aware => true do
      param :current_password, String, :required => true, :desc => 'Password'
    end
  end

  def_param_group :user_password_update do
    param :user, Hash, :action_aware => true do
      param :new_password, String, :required => true, :desc => 'Password'
      param :new_password_confirmation, String, :required => true, :desc => 'Must match Password'
    end
  end

  def_param_group :user_request do
    param :user, Hash, :action_aware => true do
      param_group :user_fields
    end
  end

  def_param_group :user_response do
    property :id, Integer, :desc => 'The unique ID of this User'
    param_group :user_fields
    property :created_at, DateTime, :desc => 'When the User was created'
    property :updated_at, DateTime, :desc => 'When the User was last updated'
  end

  # GET /api/users
  api! 'List all Users'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  returns :array_of => :user_response, :code => :ok, :desc => 'A list of all Users'

  def index
    @users = User.all

    render json: @users
  end

  # GET /api/users/:user_id
  api! 'User Details'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  returns :user_response, :code => :ok, :desc => 'The details of the specified User'

  def show
    render json: @user
  end

  # POST /api/users
  api! 'Create a User'
  error :code => :unprocessable_entity, :desc => 'Unprocessable Entity'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  param_group :user_request
  param_group :user_password
  param_group :user_password_confirmation
  returns :user_response, :code => :created, :desc => 'The details of the created User'

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :internal_server_error
    end
  end

  # PATCH/PUT /api/users/:user_id
  # TODO: return unless @user == current_user
  api! 'Update the details of an existing User'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :unprocessable_entity, :desc => 'Unprocessable Entity'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  param_group :user_request
  param_group :user_password_check
  param_group :user_password_update
  returns :user_response, :code => :created, :desc => 'The details of the updated User'

  def update
    render json: { 'message' => 'Cannot update other Users' } unless @user == current_user

    @user = current_user
    @user.errors_add(:current_password, 'is incorrect') unless @user.authenticate(params[:current_password])

    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /api/users/:user_id
  # TODO: return unless @user == current_user
  api! 'Mark the specified User as "inactive"'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :unprocessable_entity, :desc => 'Unprocessable Entity'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  param_group :user_request
  param_group :user_password
  returns :user_response, :code => :created, :desc => 'The details of the "inactive" User'

  def destroy
    @user.update(active: false)
  end

  # GET /api/users/:user_id/organisations
  def index_associated_organisations
    render json: { 'status' => 'pending', 'params' => params }
    # @user_organisations = User.find(params[:id]).organisations

    render json: @user_organisations
  end

  # POST /api/users/:user_id/organisations/:organisation_id
  def join_organisation
    render json: { 'status' => 'pending', 'params' => params }
  end

  # DELETE /api/users/:user_id/organisations/:organisation_id
  def leave_organisation
    render json: { 'status' => 'pending', 'params' => params }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter 'white list' through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
  end
end
