class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update]
  before_action :prevent_duplicate_sign_in, only: [:create, :new]

  def create
    @user = User.new(user_params)
    if session[:auth].present?
      @user.email = session[:auth]["info"]["email"]
      @user.password = SecureRandom.base64
      identity = Identity.new(provider: session[:auth]["provider"], uid: session[:auth]["uid"], user: @user)
      if @user.save && identity.save
        session.delete(:auth)
        @user.update_attributes(confirmed_at: Time.now)
        sign_in(@user)
        remember(@user)
        redirect_to post_auth_path
      else
        flash.now[:alert] = "There was a problem with your registration."
        render "identities/new"
      end
    else
      if verify_recaptcha(model: @user) && @user.save
        @user.send_confirmation_email
        flash[:success] = "Registration successful. Please confirm your email to activate your account."
        redirect_to root_path
      else
        flash.now[:alert] = "There was a problem with your registration."
        render :new
      end
    end
  end

  def edit
    @user = User.find_by(handle: params[:id])
    authorize_user(@user)
  end

  def new
    session.delete(:auth)
    @user = User.new
    @times = User::REMINDER_TIMES
  end

  def update
    @user = User.find_by(handle: params[:id])
    authorize_user(@user)
    if (!@user.identities.empty? || @user.authenticate(params[:user][:password]))
      @user.assign_attributes(update_params)
      if @user.changed.include?("email") && @user.valid?
        @user.confirmed_at = nil
        @user.send(:generate_confirmation_digest)
        @reconfirm = true
        sign_out
      end
      if @user.save
        if @reconfirm
          @user.send_confirmation_email
          flash[:success] = "Update successful. Please confirm your email to re-activate your account."
        else
          flash[:success] = "Update successful."
        end
        redirect_to root_path
      else
        flash.now[:alert] = "There was a problem with your update."
        render :edit
      end
    else
      flash.now[:alert] = "There was a problem with your update."
      render :edit
    end
  end

  protected

  def authorize_user(user)
    unless user == current_user
      flash[:alert] = "You are not authorized for this record."
      redirect_to root_path
    end
  end

  def update_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def user_params
    params.require(:user).permit(:handle, :email, :first_name, :last_name, :password, :password_confirmation, :reminder_active, :reminder_time, :time_zone)
  end

end
