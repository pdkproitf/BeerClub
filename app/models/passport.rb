class Passport < ApplicationRecord
  belongs_to :customer
  has_many :passport_beers
  has_many :beers, through: :passport_beers

  validates :name, presence: true
end
