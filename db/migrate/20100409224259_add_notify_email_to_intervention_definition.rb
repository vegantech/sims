class AddNotifyEmailToInterventionDefinition < ActiveRecord::Migration
  def self.up
    add_column :intervention_definitions, :notify_email, :string
  end

  def self.down
    remove_column :intervention_definitions, :notify_email
  end
end
