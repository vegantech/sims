class CreateBehaviorReferrals < ActiveRecord::Migration
  def self.up
    create_table :behavior_referrals do |t|
      t.belongs_to :school
      t.belongs_to :student
      t.integer :end_year
      t.integer :recorder_id
      t.integer :reported_by
      t.integer :motivation
      t.integer :behavior
      t.integer :admin_decision
      t.integer :half_days_of_suspension
      t.datetime :time
      t.integer :location
      t.text :other

      t.timestamps
    end
  end

  def self.down
    drop_table :behavior_referrals
  end
end
