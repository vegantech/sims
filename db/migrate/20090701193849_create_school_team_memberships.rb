class CreateSchoolTeamMemberships < ActiveRecord::Migration
  def self.up
    create_table :school_team_memberships do |t|
      t.belongs_to :school_team
      t.belongs_to :user
      t.boolean :contact, default: false

      t.timestamps
    end
    if ActiveRecord::Base.connection.tables.include? 'school_teams_users'
      drop_table :school_teams_users
    end
  end

  def self.down
    drop_table :school_team_memberships
  end
end
