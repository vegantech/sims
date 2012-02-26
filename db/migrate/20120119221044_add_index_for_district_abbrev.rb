class AddIndexForDistrictAbbrev < ActiveRecord::Migration
  def self.up
    add_index :districts, :abbrev
  end

  def self.down
    remove_index :districts, :column => :abbrev
  end
end
