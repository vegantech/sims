class AddIdDistrictKeyToUsers < ActiveRecord::Migration
  def self.up
    remove_index "users", ["district_id"]
    add_index "users", ["district_id","id_district"]

    remove_index "schools", ["district_id"]
    add_index "schools", ["district_id","id_district"]
  end

  def self.down
    remove_index "schools", :column => ["district_id","id_district"]
    add_index "schools", ["district_id"]

    remove_index "users", :column => ["district_id","id_district"]
    add_index "users", ["district_id"]
  end
end
