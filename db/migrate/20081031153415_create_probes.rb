class CreateProbes < ActiveRecord::Migration
  def self.up
    create_table :probes do |t|
      t.datetime :administered_at
      t.integer :score
      t.string :assessment_type
      t.belongs_to :district
      t.belongs_to :intervention_probe_assignmnet

      t.timestamps
    end
  end

  def self.down
    drop_table :probes
  end
end
