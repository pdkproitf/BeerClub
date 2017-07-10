class AddUserToPassport < ActiveRecord::Migration[5.0]
  def change
    add_reference :passports, :user, foreign_key: true
  end
end
