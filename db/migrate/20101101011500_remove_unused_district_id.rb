class RemoveUnusedDistrictId < ActiveRecord::Migration
  def self.up
    remove_column :flags, :district_id
    remove_column :probes, :district_id
    remove_column :recommendation_definitions, :district_id
  end

  def self.down
    add_column :recommendation_definitions, :district_id, :integer
    add_column :probes, :district_id, :integer
    add_column :flags, :district_id, :integer
  end
end
