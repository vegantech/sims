class AddDefaultValueToEncryptedPassword < ActiveRecord::Migration
  def self.up
    change_column :users, :encrypted_password, :string, default: "", null: false
  end

  def self.down
    change_column :users, :encrypted_password, :string, default: nil, null: true
  end
end
