class Category < ApplicationRecord
  has_many :beers, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: Settings.name_min_length }

  # check any beer are seling on category.
  def using?
    beers.each do |beer|
      return true unless beer.archived
    end
    false
  end
end
