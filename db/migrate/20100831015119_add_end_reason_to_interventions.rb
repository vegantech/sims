class AddEndReasonToInterventions < ActiveRecord::Migration
  def self.up
    unless Intervention.column_names.include?("end_reason") 
      add_column :interventions, :end_reason,:string
    end
  end

  def self.down
    remove_column :interventions, :end_reason
  end
end
