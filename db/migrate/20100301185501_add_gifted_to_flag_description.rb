class AddGiftedToFlagDescription < ActiveRecord::Migration
  def self.up
    add_column :flag_descriptions, :gifted, :text
  end

  def self.down
    remove_column :flag_descriptions, :gifted
  end
end
