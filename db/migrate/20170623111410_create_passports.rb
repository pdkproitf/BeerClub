class CreatePassports < ActiveRecord::Migration[5.0]
  def change
    create_table :passports do |t|
      t.string :name

      t.timestamps
    end
  end
end
