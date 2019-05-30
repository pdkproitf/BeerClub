class ChangeUserTokensType < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :tokens, :jsonb
    add_column :users, :tokens, :jsonb
  end
end
