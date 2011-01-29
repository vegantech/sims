class CreatePersonalGroups < ActiveRecord::Migration
  def self.up
    create_table :personal_groups do |t|
      t.belongs_to :user
      t.belongs_to :school
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :personal_groups
  end
end
