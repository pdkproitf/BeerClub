class Bar < ApplicationRecord
  has_many :members
  has_many :users, through: :members
  has_many :bar_categories
  has_many :categories, through: :bar_categories

  validates :name, presence: true, uniqueness: false
end
