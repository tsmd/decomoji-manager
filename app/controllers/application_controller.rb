class ApplicationController < ActionController::Base
  http_basic_authenticate_with(
    name: Rails.application.credentials.dig(:basic_auth, :username),
    password: Rails.application.credentials.dig(:basic_auth, :password),
  )
end
