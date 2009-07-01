class AddCompleteAndChangeRecipientToTeam < ActiveRecord::Migration
  def self.up
    rename_column :team_consultations, :recipient_id, :team_id
    add_column :team_consultations, :complete, :boolean, :default => false
  end

  def self.down
    remove_column :team_consultations, :complete
    rename_column :team_consultations, :team_id, :recipient_id
  end
end
