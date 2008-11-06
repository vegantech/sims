class CreateProbeAnswer < ActiveRecord::Migration
  def self.up
    create_table :probes_probe_questions, :id => false do |t|
      t.column :probe_id, :integer
      t.column :probe_question_id, :integer
    end


  end

  def self.down
    drop_table :probes_probe_questions
  end
end

