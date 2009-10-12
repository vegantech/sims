class CreateExtTestScores < ActiveRecord::Migration
  def self.up
    create_table :ext_test_scores do |t|
      t.belongs_to :student
      t.string :name
      t.date :date
      t.float :scaleScore
      t.string :result
      t.date :enddate

      t.timestamps
    end
  end

  def self.down
    drop_table :ext_test_scores
  end
end
