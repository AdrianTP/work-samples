class ApplicationController < ActionController::API
  # include Knock::Authenticable
  # before_action :authenticate_user

  rescue_from Apipie::ParamError do |e|
    render status: :unprocessable_entity, json: { message: e.message }
  end
end
