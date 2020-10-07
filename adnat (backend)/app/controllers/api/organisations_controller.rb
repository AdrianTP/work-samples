class Api::OrganisationsController < ApplicationController
  before_action :set_organisation, only: [:show, :update]

  def_param_group :organisation_fields do
      param :name, String, :required => true, :desc => 'Name of the Organisation'
      param :hourly_rate, Float, :required => true, :desc => 'Hourly pay in dollars and cents'
  end

  def_param_group :organisation_request do
    param :organisation, Hash, :action_aware => true do
      param_group :organisation_fields
    end
  end

  def_param_group :organisation_response do
    property :id, Integer, :desc => 'The unique ID of this Organisation'
    param_group :organisation_fields
    property :created_at, DateTime, :desc => 'When the Organisation was created'
    property :updated_at, DateTime, :desc => 'When the Organisation was last updated'
  end

  # GET /api/organisations
  api! 'List all Organisations'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  returns :array_of => :organisation_response, :code => :ok, :desc => 'A list of all Organisations'

  def index
    @organisations = Organisation.all

    render json: @organisations
  end

  # GET /api/organisations/:organisation_id
  api! 'Organisation Details'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  returns :organisation_response, :code => :ok, :desc => 'The details of the specified Organisation'

  def show
    render json: @organisation
  end

  # POST /api/organisations
  api! 'Create an Organisation'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :unprocessable_entity, :desc => 'Unprocessable Entity'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  param_group :organisation_request
  returns :organisation_response, :code => :created, :desc => 'The details of the created Organisation'

  def create
    @organisation = Organisation.new(organisation_params)

    if @organisation.save
      render json: @organisation, status: :created, location: api_organisation_url(@organisation)
    else
      render json: @organisation.errors, status: :internal_server_error
    end
  end

  # PATCH/PUT /api/organisations/:organisation_id
  api! 'Update the details of an existing Organisation'
  error :code => :unauthorized, :desc => 'Unauthorized'
  error :code => :unprocessable_entity, :desc => 'Unprocessable Entity'
  error :code => :internal_server_error, :desc => 'Internal Server Error'
  param_group :organisation_request
  returns :organisation_response, :code => :created, :desc => 'The details of the updated Organisation'

  def update
    if @organisation.update(organisation_params)
      render json: @organisation, status: :ok
    else
      render json: @organisation.errors, status: :internal_server_error
    end
  end

  # GET /api/organisations/:organisation_id/users
  def index_associated_users
    @organisation_users = Organisation
      .find(params[:organisation_id])
      .user

    render json: @organisation_users
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organisation
    @organisation = Organisation.find(params[:id])
  end

  # Only allow a trusted parameter 'white list' through.
  def organisation_params
    params.require(:organisation).permit(:name, :hourly_rate)
  end
end
