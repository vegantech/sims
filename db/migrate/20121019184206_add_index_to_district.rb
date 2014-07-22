class AddIndexToDistrict < ActiveRecord::Migration
  def self.up
    add_index :districts, [:admin,:name]
  end

  def self.down
    remove_index :districts, column: [:admin,:name]
  end
end
