class AddBarReferenceToCategory < ActiveRecord::Migration[5.0]
  def change
    add_reference :categories, :bar, foreign_key: true
  end
end
