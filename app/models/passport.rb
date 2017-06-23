class Passport < ApplicationRecord
  has_many :passport_beers
  has_many :beers, through: :passport_beers

  validates :name, presence: true
end
