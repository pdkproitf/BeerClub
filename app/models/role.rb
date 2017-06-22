class Role < ApplicationRecord
  has_many :members

  validates :name, presence: true, uniqueness: false
end
