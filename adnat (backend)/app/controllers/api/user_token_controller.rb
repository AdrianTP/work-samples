class Api::UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, raise: false
  # NOTE: This is empty on purpose
  # TODO: validate all inputs, consider apipie-rails
  # POST /api/auths
end
