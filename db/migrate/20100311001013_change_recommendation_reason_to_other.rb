class ChangeRecommendationReasonToOther < ActiveRecord::Migration
  def self.up
    rename_column :recommendations, :reason, :other 
  end

  def self.down
    rename_column :recommendations, :other , :reason
  end
end
