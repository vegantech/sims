class RemoveRolesTable < ActiveRecord::Migration
  def self.up
    remove_index "roles_users", :name => "index_roles_users_on_user_id"
    remove_index "roles_users", :name => "index_roles_users_on_role_id"

    drop_table "roles_users"

    remove_index "roles", :name => "index_roles_on_district_id"

    drop_table "roles"
  end

  def self.down
    create_table "roles", :force => true do |t|
      t.string   "name"
      t.integer  "district_id"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "asset_file_name"
      t.string   "asset_content_type"
      t.integer  "asset_file_size"
      t.datetime "asset_updated_at"
    end

    add_index "roles", ["district_id"], :name => "index_roles_on_district_id"

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id"
      t.integer "user_id"
    end

    add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
    add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"
  end
end
