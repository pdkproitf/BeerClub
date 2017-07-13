class Role < ApplicationRecord
  has_many :users, class_name: 'User', foreign_key: 'role_id'

  validates :name, presence: true, uniqueness: true
end
