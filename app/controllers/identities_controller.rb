class IdentitiesController < ApplicationController

  def create
    identity = Identity.find_by(provider: request.env["omniauth.auth"]["provider"], uid: request.env["omniauth.auth"]["uid"])
    if identity.present?
      sign_in(identity.user)
      remember(identity.user)
      flash[:success] = "Signed in as #{identity.user.handle}."
      redirect_to post_auth_path
    else
      session[:auth] = request.env["omniauth.auth"].slice("info","provider","uid")
      user = User.find_by(email: session[:auth]["info"]["email"])
      if user.present?
        redirect_to edit_user_identity_path(user, session[:auth]["provider"])
      else
        redirect_to sign_up_path
      end
    end
  end

  def edit
    @user = User.find_by(handle: params[:user_id])
    @provider = session[:auth]["provider"]
    redirect_to sign_in_path unless @user.identities.where(provider: @provider).empty?
  end

  def new
    if session[:auth].present?
      @user = User.new
      if session[:auth]["info"]["first_name"].present?
        @first_name = session[:auth]["info"]["first_name"]
        @last_name = session[:auth]["info"]["last_name"]
      else
        @first_name = session[:auth]["info"]["name"].split(" ").first
        @last_name = session[:auth]["info"]["name"].split(" ").last
      end
      @times = User::REMINDER_TIMES
    else
      redirect_to sign_in_path
    end
  end

  def update
    user = User.find_by(handle: params[:user_id])
    identity = Identity.new(provider: session[:auth]["provider"], uid: session[:auth]["uid"], user: user)
    if identity.save
      session.delete(:auth)
      sign_in(user)
      remember(user)
      flash[:success] = "Accounts linked successfully. Signed in as #{user.handle}."
      redirect_to post_auth_path
    else
      flash[:alert] = "There was an error linking your accounts."
      redirect_to sign_in_path
    end
  end

end
