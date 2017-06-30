class ChangeCustomerTokenType < ActiveRecord::Migration[5.0]
  def change
    remove_column :customers, :tokens, :jsonb
    add_column :customers, :tokens, :jsonb
  end
end
