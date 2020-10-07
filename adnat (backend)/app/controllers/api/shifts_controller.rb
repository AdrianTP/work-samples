class Api::ShiftsController < ApplicationController
  # before_action :set_shift, only: [:show, :update]

  # TODO: validate all inputs, consider apipie-rails

  # GET /api/shifts
  def index
    render json: { 'status' => 'pending', 'params' => params }
    # @shifts = Shift.all.includes(:breaks)

    # render json: @shifts
  end

  # GET /api/shifts/:shift_id
  def show
    render json: { 'status' => 'pending', 'params' => params }
    # render json: @shift
  end

  # PATCH/PUT /api/shifts/:shift_id
  def update
    render json: { 'status' => 'pending', 'params' => params }
    # if @shift.update(shift_params)
    #   render json: @user
    # else
    #   render json: @user.errors, status: :unprocessable_entity
    # end
  end

  # DELETE /api/shifts/:shift_id
  def destroy
    render json: { 'status' => 'pending', 'params' => params }
  end

  # GET /api/users/:user_id/shifts
  def index_for_user
    render json: { 'status' => 'pending', 'params' => params }
  end

  # POST /api/users/:user_id/shifts
  def create_for_user
    render json: { 'status' => 'pending', 'params' => params }
    # @shift = User.find(user_params).shifts.create(shift_params)

    # if @shift.save
    #   render json: @shift, status: :created, location: @shift
    # else
    #   render json: @shift.errors, status: :unprocessable_entity
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shift
    @shift = Shift.find(params[:id]).includes(:breaks)
  end

  # Only allow a trusted parameter 'white list' through.
  def shift_params
    params.require(:shift).permit(:start, :finish, :breaks)
  end
end
