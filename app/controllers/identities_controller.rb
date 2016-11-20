class IdentitiesController < ApplicationController

  def create
    identity = Identity.find_by(provider: request.env["omniauth.auth"]["provider"], uid: request.env["omniauth.auth"]["uid"])
    if identity.present?
      sign_in(identity.user)
      remember(identity.user)
      redirect_to post_auth_path
    else
      session[:auth] = request.env["omniauth.auth"].slice("info","provider","uid")
      redirect_to sign_up_path
    end
  end

  def new
    if session[:auth].present?
      @user = User.new
      @first_name = session[:auth]["info"]["first_name"]
      @last_name = session[:auth]["info"]["last_name"]
      @times = User::REMINDER_TIMES
    else
      redirect_to sign_in_path
    end
  end

end
