class CreateTeamSchedulers < ActiveRecord::Migration
  def self.up
    create_table :team_schedulers do |t|
      t.belongs_to :user
      t.belongs_to :school

      t.timestamps
    end
  end

  def self.down
    drop_table :team_schedulers
  end
end
