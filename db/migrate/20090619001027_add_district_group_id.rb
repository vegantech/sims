class AddDistrictGroupId < ActiveRecord::Migration
  def self.up
    add_column :groups, :id_district, :string
    add_index :groups, :id_district
  end

  def self.down
    remove_index :groups, :column => :id_district
    remove_column :groups, :id_district
  end
end
