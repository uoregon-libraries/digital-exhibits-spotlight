# frozen_string_literal: true

# This handles the omniauth callback to grab a user and sign them in
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[saml failure]

  def saml
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect(@user)
      set_flash_message(:notice, :success, kind: "Spotlight") if is_navigational_format?
    else
      redirect_to root_path, :alert => "User not found, please contact site administrator if assistance needed."
    end
  end

  def failure
    redirect_to root_path
  end
end

