class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.text :text
      t.boolean :system
      t.belongs_to :district
      t.belongs_to :school
      t.belongs_to :state
      t.belongs_to :country

      t.timestamps
    end
  end

  def self.down
    drop_table :news_items
  end
end
