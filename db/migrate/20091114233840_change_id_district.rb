class ChangeIdDistrict < ActiveRecord::Migration
  def self.up
    rename_column :students, :id_district, :district_student_id
    rename_column :users, :id_district, :district_user_id
    rename_column :groups, :id_district, :district_group_id
    rename_column :schools, :id_district, :district_school_id
    

  end

  def self.down
    rename_column :schools, :district_school_id, :id_district
    rename_column :groups, :district_group_id, :id_district
    rename_column :users, :district_user_id, :id_district
    rename_column :students, :district_student_id, :id_district
  end
end
