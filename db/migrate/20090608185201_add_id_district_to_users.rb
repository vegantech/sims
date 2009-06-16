class AddIdDistrictToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :id_district, :integer
  end

  def self.down
    remove_column :users, :id_district
  end
end
