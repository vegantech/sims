class RemoveDistrictIdAndGrouptypeFromSpecialUserGroups < ActiveRecord::Migration
  def self.up
    remove_index  "special_user_groups", ["district_id"]
    remove_column :special_user_groups, :district_id
    remove_column :special_user_groups, :grouptype
  end

  def self.down
    add_column :special_user_groups, :grouptype, :integer
    add_column :special_user_groups, :district_id, :integer
    add_index  "special_user_groups", "district_id"
  end
end
