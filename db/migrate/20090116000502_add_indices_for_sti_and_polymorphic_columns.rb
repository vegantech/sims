class AddIndicesForStiAndPolymorphicColumns < ActiveRecord::Migration
  def self.up
    add_index :flags, :type
  end

  def self.down
    remove_index :flags, column: :type
  end
end
