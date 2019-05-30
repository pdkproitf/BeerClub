class RemoveCountFromBeer < ActiveRecord::Migration[5.0]
  def change
    remove_column :beers, :count
  end
end
