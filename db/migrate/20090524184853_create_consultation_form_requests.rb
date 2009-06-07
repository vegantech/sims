class CreateConsultationFormRequests < ActiveRecord::Migration
  def self.up
    create_table :consultation_form_requests do |t|
      t.belongs_to :student
      t.belongs_to :requestor
      t.belongs_to :team
      t.boolean :all_student_scheduled_staff

      t.timestamps
    end
  end

  def self.down
    drop_table :consultation_form_requests
  end
end
