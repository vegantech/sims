class CreateFlagDescriptions < ActiveRecord::Migration
  def self.up
    create_table :flag_descriptions do |t|
      t.belongs_to :district
      t.text :languagearts
      t.text :math
      t.text :suspension
      t.text :attendance

      t.timestamps
    end
  end

  def self.down
    drop_table :flag_descriptions
  end
end
