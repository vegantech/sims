class RemoveRightsTable < ActiveRecord::Migration
  def self.up
    drop_table :rights
  end

  def self.down
    create_table "rights", :force => true do |t|
      t.string   "controller"
      t.boolean  "read_access"
      t.boolean  "write_access"
      t.integer  "role_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "rights", ["role_id"], :name => "index_rights_on_role_id"
  end
end
