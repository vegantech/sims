class CreateInterventions < ActiveRecord::Migration
  def self.up
    create_table :interventions do |t|
      t.belongs_to :user
      t.belongs_to :student
      t.date :start_date
      t.date :end_date
      t.belongs_to :intervention_definition
      t.belongs_to :frequency
      t.integer :frequency_multiplier
      t.belongs_to :time_length
      t.integer :time_length_number
      t.boolean :active,default: true
      t.belongs_to :ended_by
      t.date :ended_at

      t.timestamps
    end
  end

  def self.down
    drop_table :interventions
  end
end
