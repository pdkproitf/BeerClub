class Category < ApplicationRecord
  belongs_to :bar

  validates :name, presence: true, uniqueness: true, length: { minimum: Settings.name_min_length }
end
