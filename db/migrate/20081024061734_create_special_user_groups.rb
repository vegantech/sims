class CreateSpecialUserGroups < ActiveRecord::Migration
  def self.up
    create_table :special_user_groups do |t|
      t.belongs_to :user
      t.belongs_to :district
      t.belongs_to :school
      t.integer :grouptype
      t.string :grade
      t.string :integer
      t.boolean :is_principal, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :special_user_groups
  end
end
