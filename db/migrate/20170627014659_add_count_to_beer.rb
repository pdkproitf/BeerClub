class AddCountToBeer < ActiveRecord::Migration[5.0]
  def change
    add_column :beers, :count, :Integer, default: 1
  end
end
