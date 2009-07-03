class CreateTeamAgendas < ActiveRecord::Migration
  def self.up
    create_table :team_agendas do |t|
      t.belongs_to :team
      t.date :date
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :team_agendas
  end
end
