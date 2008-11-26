class CreateInterventionComments < ActiveRecord::Migration
  def self.up
    create_table :intervention_comments do |t|
      t.belongs_to :intervention
      t.text :comment
      t.belongs_to :user

      t.timestamps
    end
  end

  def self.down
    drop_table :intervention_comments
  end
end
