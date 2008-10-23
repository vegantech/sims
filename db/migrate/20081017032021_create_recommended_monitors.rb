class CreateRecommendedMonitors < ActiveRecord::Migration
  def self.up
    create_table :recommended_monitors do |t|
      t.belongs_to :intervention_definition
      t.belongs_to :probe_definition
      t.string :note
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :recommended_monitors
  end
end
