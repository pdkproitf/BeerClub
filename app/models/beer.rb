class Beer < ApplicationRecord
  belongs_to :category
  has_many :passport_beers
  has_many :passports, through: :passport_beers

  validates_presence_of :manufacurter, :name, :country, :price, :description
  validates :name, uniqueness: true, length: { minimum: Settings.name_min_length }
  validates :price, numericality: { greater_than_or_eq: 0 }
end
