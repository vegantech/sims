class AddScienceAndSocialstudiesFlagDescription < ActiveRecord::Migration
  def self.up
    add_column :flag_descriptions,:science, :text
    add_column :flag_descriptions,:socialstudies, :text
  end

  def self.down
    remove_column :flag_descriptions,:socialstudies
    remove_column :flag_descriptions,:science
  end
end
