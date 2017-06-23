class Category < ApplicationRecord
  belongs_to :bar
  has_many :beers

  validates :name, presence: true, uniqueness: true, length: { minimum: Settings.name_min_length }
end
