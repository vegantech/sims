class AddChecklistFieldsToRecommendation < ActiveRecord::Migration
  def self.up
    add_column :recommendations, :draft, :boolean, :default=>false
    add_column :recommendations, :district_id, :integer
    add_column :recommendations, :tier_id, :integer
    add_column :recommendations, :student_id, :integer 
    add_column :recommendations, :promoted, :boolean, :default=>false
  end

  def self.down
    remove_column :recommendations, :promoted
    remove_column :recommendations, :student_id
    remove_column :recommendations, :tier_id
    remove_column :recommendations, :district_id
    remove_column :recommendations, :draft
  end
end
