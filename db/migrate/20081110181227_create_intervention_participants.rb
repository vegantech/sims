class CreateInterventionParticipants < ActiveRecord::Migration
  def self.up
    create_table :intervention_participants do |t|
      t.belongs_to :intervention
      t.belongs_to :user
      t.integer :role, :default=>InterventionParticipant::PARTICIPANT

      t.timestamps
    end
  end

  def self.down
    drop_table :intervention_participants
  end
end
