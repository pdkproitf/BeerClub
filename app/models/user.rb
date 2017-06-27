class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
  # after_create :send_confirmation_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  belongs_to :role

  validates :email, presence: true, length: { maximum: Settings.mail_max_length },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, allow_nil: true,
                      length: { minimum: Settings.password_min_length }

  before_save :downcase_email

  private
  # Converts email to all lower-case
  def downcase_email
    self.email = email.downcase
  end
end
