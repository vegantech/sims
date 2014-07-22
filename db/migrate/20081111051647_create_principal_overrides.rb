class CreatePrincipalOverrides < ActiveRecord::Migration
  def self.up
    create_table :principal_overrides do |t|
      t.belongs_to :teacher
      t.belongs_to :student
      t.belongs_to :principal
      t.integer :status, default: PrincipalOverride::NEW_REQUEST
      t.belongs_to :start_tier
      t.belongs_to :end_tier
      t.string :principal_response, limit: 1024
      t.string :teacher_request, limit: 1024

      t.timestamps
    end
  end

  def self.down
    drop_table :principal_overrides
  end
end
