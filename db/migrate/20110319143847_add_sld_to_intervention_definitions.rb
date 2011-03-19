class AddSldToInterventionDefinitions < ActiveRecord::Migration
  def self.up
    add_column :intervention_definitions, :sld, :set, 
      :limit =>"'oral expression','listening comprehension','written expression','basic reading skill','reading fluency','reading comprehension','mathematics calculation','mathematics problem solving'",
      :null=>'false', :default=>''
  end

  def self.down
    remove_column :intervention_definitions, :sld
  end
end
