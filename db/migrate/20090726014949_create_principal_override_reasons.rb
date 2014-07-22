class CreatePrincipalOverrideReasons < ActiveRecord::Migration
  def self.up
    create_table :principal_override_reasons do |t|
      t.belongs_to :district
      t.text :reason
      t.boolean :autopromote, default: false

      t.timestamps
    end
  end

  def self.down
    drop_table :principal_override_reasons
  end
end
