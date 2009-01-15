class CreateDistrictFlagCategories < ActiveRecord::Migration
  def self.up
    create_table :flag_categories do |t|
      t.belongs_to :district
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :flag_categories
  end
end
