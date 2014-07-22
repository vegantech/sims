class AdjustVarcharSizes < ActiveRecord::Migration
  def self.up
    change_column :groups, :district_group_id, :string, limit: 20, null: false, default: ''
    change_column :students, :district_student_id, :string, limit: 40, null: false, default: ''
    change_column :users, :district_user_id, :string, limit: 40, null: false, default: ''
    change_column :users, :username, :string, limit: 100
    change_column :flags, :category, :string, limit: 15, null: false
    change_column :flags, :type ,:string, limit: 10, null: false
  end

  def self.down
    change_column :flags, :type, :string, limit: 255, null: true, default: nil
    change_column :flags, :category, :string, limit: 255, null: true, default: nil
    change_column :users, :username, :string, limit: 255
    change_column :users, :district_user_id, :string, limit: 255, null: true, default: nil
    change_column :students, :district_student_id, :string, limit: 255, null: true, default: nil
    change_column :groups, :district_group_id, :string, limit: 255, null: true, default: nil
  end
end
