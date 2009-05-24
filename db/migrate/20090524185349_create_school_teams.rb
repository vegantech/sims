class CreateSchoolTeams < ActiveRecord::Migration
  def self.up
    create_table :school_teams do |t|
      t.belongs_to :school
      t.string :name
      t.boolean :anonymous

      t.timestamps
    end
  end

  def self.down
    drop_table :school_teams
  end
end
