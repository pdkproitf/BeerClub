class CreateBeers < ActiveRecord::Migration[5.0]
  def change
    create_table :beers do |t|
      t.string :manufacurter
      t.string :name
      t.references :category, foreign_key: true
      t.string :country
      t.float :price,  default: 0
      t.text :description
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
