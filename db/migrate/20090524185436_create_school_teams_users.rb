class CreateSchoolTeamsUsers < ActiveRecord::Migration
  def self.up
    create_table :school_teams_users, id: false do |t|
      t.column :school_team_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :school_teams_users
  end
end
