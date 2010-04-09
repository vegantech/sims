class AddDraftToTeamConsultation < ActiveRecord::Migration
  def self.up
    add_column :team_consultations, :draft, :boolean, :default => false
  end

  def self.down
    remove_column :team_consultations, :draft
  end
end
