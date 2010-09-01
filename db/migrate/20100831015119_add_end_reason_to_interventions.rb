class AddEndReasonToInterventions < ActiveRecord::Migration
  def self.up
    add_column :interventions, :end_reason,:string
  end

  def self.down
    remove_column :interventions, :end_reason
  end
end
