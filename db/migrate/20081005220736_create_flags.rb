class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.string :category
      t.belongs_to :user
      t.belongs_to :district
      t.belongs_to :student
      t.text :reason
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :flags
  end
end
