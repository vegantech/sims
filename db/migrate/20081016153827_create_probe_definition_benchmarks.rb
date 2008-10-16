class CreateProbeDefinitionBenchmarks < ActiveRecord::Migration
  def self.up
    create_table :probe_definition_benchmarks do |t|
      t.belongs_to :probe_definition
      t.integer :benchmark
      t.integer :grade_level

      t.timestamps
    end
  end

  def self.down
    drop_table :probe_definition_benchmarks
  end
end
