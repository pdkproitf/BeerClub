class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
  # after_create :send_confirmation_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  belongs_to  :role
  has_many    :messages
  has_many    :conversations, foreign_key: :sender_id
  has_one     :passport 

  validates :email, presence: true, length: { maximum: Settings.mail_max_length },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, allow_nil: true,
                      length: { minimum: Settings.password_min_length }

  before_save :downcase_email
  after_create :add_passport, if: :customer?

  def admin?
    role.name == 'Admin'
  end

  def customer?
    role.name == 'Customer'
  end

  private
  # Converts email to all lower-case
  def downcase_email
    self.email = email.downcase
  end

  def add_passport
    create_passport!(name: name)
  end
end
