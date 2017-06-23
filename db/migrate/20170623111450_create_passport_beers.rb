class CreatePassportBeers < ActiveRecord::Migration[5.0]
  def change
    create_table :passport_beers do |t|
      t.references :passport, foreign_key: true
      t.references :beer, foreign_key: true

      t.timestamps
    end
  end
end
