class ApplicationController < ActionController::Base
  # production 環境で Basic 認証をかける
  if Rails.env.production?
    http_basic_authenticate_with(
      name: Rails.application.credentials.dig(:basic_auth, :username),
      password: Rails.application.credentials.dig(:basic_auth, :password),
    )
  end
end
