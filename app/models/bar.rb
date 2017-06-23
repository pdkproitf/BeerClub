class Bar < ApplicationRecord
  has_many :members
  has_many :users, through: :members
  has_many :categories
  has_many :beers, through: :categories

  validates :name, presence: true, uniqueness: true
end
