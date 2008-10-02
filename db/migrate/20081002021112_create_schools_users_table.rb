class CreateSchoolsUsersTable < ActiveRecord::Migration
  def self.up
    create_table :schools_users do |t|
      t.column :user_id, :integer
      t.column :school_id, :integer
    end

  end

  def self.down
    drop_table :schools_users
  end
end
