class AddStudentToConsultationForm < ActiveRecord::Migration
  def self.up
    add_column :consultation_forms, :student_id, :integer
  end

  def self.down
    remove_column :consultation_forms, :student_id
  end
end
