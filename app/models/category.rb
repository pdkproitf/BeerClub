class Category < ApplicationRecord
  belongs_to :bar
  has_many :beers, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: Settings.name_min_length }

  def using?
    beers.each do |beer|
      return true if beer.archived
    end
    false
  end
end
