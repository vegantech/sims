class RemoveCountriesAndStates < ActiveRecord::Migration
  def self.up
    drop_table :states
    drop_table :countries
    remove_column :news_items, :country_id
    remove_column :news_items, :state_id
    remove_column :districts, :state_id





  end

 def self.down
  add_column :news_items, :state_id,:integer
  add_column :news_items, :country_id,:integer
  add_index "news_items", ["country_id"], :name => "index_news_items_on_country_id"
  add_index "news_items", ["state_id"], :name => "index_news_items_on_state_id"

   add_column :districts, :state_id, :integer
   add_index "districts", ["state_id"], :name => "index_districts_on_state_id"
    create_table :countries do |t|
      t.string :name
      t.string :abbrev

      t.timestamps
    end
    add_index :countries, :abbrev

    create_table "states", :force => true do |t|
      t.string   "name"
      t.string   "abbrev"
      t.integer  "country_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "admin",      :default => false
    end

    add_index "states", ["country_id"], :name => "index_states_on_country_id"




  end

end
