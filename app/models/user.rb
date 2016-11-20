class User < ApplicationRecord
  EMAIL_REGEXP = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  HANDLE_REGEXP = /\A[A-Za-z0-9]+(?:[_-][A-Za-z0-9]+)*\z/
  REMINDER_TIMES = [
    ["midnight","00:00"],
    ["1:00am","01:00"],
    ["2:00am","02:00"],
    ["3:00am","03:00"],
    ["4:00am","04:00"],
    ["5:00am","05:00"],
    ["6:00am","06:00"],
    ["7:00am","07:00"],
    ["8:00am","08:00"],
    ["9:00am","09:00"],
    ["10:00am","10:00"],
    ["11:00am","11:00"],
    ["noon","12:00"],
    ["1:00pm","13:00"],
    ["2:00pm","14:00"],
    ["3:00pm","15:00"],
    ["4:00pm","16:00"],
    ["5:00pm","17:00"],
    ["6:00pm","18:00"],
    ["7:00pm","19:00"],
    ["8:00pm","20:00"],
    ["9:00pm","21:00"],
    ["10:00pm","22:00"],
    ["11:00pm","23:00"]
  ]

  attr_accessor :confirmation_token, :password_reset_token, :remember_token

  before_create :generate_confirmation_digest

  has_many :identities

  has_secure_password

  validates_format_of :email, with: EMAIL_REGEXP
  validates_format_of :handle, with: HANDLE_REGEXP
  validates_length_of :handle, in: 3..30
  validates_presence_of :email, :first_name, :handle, :last_name
  validates_uniqueness_of :email, :handle

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def confirm!
    touch(:confirmed_at) if confirmed_at.nil?
  end

  def confirmed?
    !confirmed_at.nil?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_remember_digest
    self.remember_token = User.new_token
    update_attributes(remember_digest: User.digest(remember_token))
  end

  def generate_reset_digest
    self.password_reset_token = User.new_token
    update_attributes(password_reset_digest: User.digest(password_reset_token), password_reset_sent_at: Time.current)
  end

  def password_reset_expired?
    (password_reset_sent_at + 2.hours).past?
  end

  def send_confirmation_email
    UserMailer.account_confirmation(self.id, self.confirmation_token).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self.id, self.password_reset_token).deliver_now
  end

  def terminate_remember_digest
    update_attributes(remember_digest: nil)
  end

  def to_param
    handle
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  protected

  def generate_confirmation_digest
    self.confirmation_token = User.new_token
    self.confirmation_digest = User.digest(confirmation_token)
  end
end
