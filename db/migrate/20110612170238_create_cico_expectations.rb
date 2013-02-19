class CreateCicoExpectations < ActiveRecord::Migration
  def self.up
    create_table :cico_expectations do |t|
      t.string :name
      t.integer :position
      t.references :cico_setting

      t.timestamps
    end
  end

  def self.down
    drop_table :cico_expectations
  end
end
