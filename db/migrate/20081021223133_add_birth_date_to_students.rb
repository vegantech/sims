class AddBirthDateToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :birthdate, :date
  end

  def self.down
    remove_column :students, :birthdate
  end
end
