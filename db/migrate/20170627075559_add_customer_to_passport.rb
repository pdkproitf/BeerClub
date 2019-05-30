class AddCustomerToPassport < ActiveRecord::Migration[5.0]
  def change
    add_reference :passports, :customer, foreign_key: true
  end
end
