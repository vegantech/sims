class CreateProbes < ActiveRecord::Migration
  def self.up
    create_table :probes do |t|
      t.datetime :administered_at
      t.integer :score
      t.belongs_to :district
      t.belongs_to :intervention_probe_assignment

      t.timestamps
    end
  end

  def self.down
    drop_table :probes
  end
end
