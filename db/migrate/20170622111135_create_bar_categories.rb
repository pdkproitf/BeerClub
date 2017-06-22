class CreateBarCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :bar_categories do |t|
      t.references :bar, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
