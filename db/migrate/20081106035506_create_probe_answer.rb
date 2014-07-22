class CreateProbeAnswer < ActiveRecord::Migration
  def self.up
    create_table :probe_questions_probes, id: false do |t|
      t.column :probe_id, :integer
      t.column :probe_question_id, :integer
    end
  end

  def self.down
    drop_table :probe_questions_probes
  end
end

