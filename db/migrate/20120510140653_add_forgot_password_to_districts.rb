class AddForgotPasswordToDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :forgot_password, :boolean, null: false, default: false
  end

  def self.down
    remove_column :districts, :forgot_password
  end
end
