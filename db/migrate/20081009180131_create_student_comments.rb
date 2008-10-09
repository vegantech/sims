class CreateStudentComments < ActiveRecord::Migration
  def self.up
    create_table :student_comments do |t|
      t.belongs_to :student
      t.belongs_to :user
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :student_comments
  end
end
