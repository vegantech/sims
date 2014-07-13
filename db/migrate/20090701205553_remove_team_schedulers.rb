class RemoveTeamSchedulers < ActiveRecord::Migration
  def self.up
    if ActiveRecord::Base.connection.tables.include? 'team_schedulers'
      drop_table :team_schedulers
    end
  end

  def self.down
  end
end

