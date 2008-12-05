class AddAdminBooleanToCountryStateDistrict < ActiveRecord::Migration
  def self.up
    add_column :countries, :admin, :boolean, :default=>false
    add_column :states, :admin, :boolean, :default=>false
    add_column :districts, :admin, :boolean, :default=>false
  end

  def self.down
    remove_column :districts, :admin
    remove_column :states, :admin
    remove_column :countries, :admin
  end
end
