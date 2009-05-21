class CreateTeamConsultations < ActiveRecord::Migration
  def self.up
    create_table :team_consultations do |t|
      t.belongs_to :student
      t.belongs_to :requestor
      t.belongs_to :recipient

      t.timestamps
    end
  end

  def self.down
    drop_table :team_consultations
  end
end
