class PassportBeer < ApplicationRecord
  belongs_to :passport
  belongs_to :beer

  validates_uniqueness_of :passport_id, scope: :beer_id
end
