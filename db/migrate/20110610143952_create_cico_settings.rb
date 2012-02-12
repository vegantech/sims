class CreateCicoSettings < ActiveRecord::Migration
  def self.up
    create_table :cico_settings do |t|
      t.references :school
      t.references :probe_definition
      t.boolean :enabled, :null => false, :default=>false
      t.references :default_participant
      t.integer :points_per_expectation, :default => 2
      t.integer :default_goal
      t.set :days_to_collect, :limit => "'monday','tuesday','wednesday','thursday','friday','saturday','sunday'",
        :default =>"monday,tuesday,wednesday,thursday,friday", :null => false

      t.timestamps
    end
    add_index :cico_settings, [:school_id, :enabled]
  end

  def self.down
    remove_index :cico_settings, :column => [:school_id, :enabled]
    drop_table :cico_settings
  end
end
