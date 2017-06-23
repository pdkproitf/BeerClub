class AddArchivedToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :archived, :boolean, default: false
  end
end
