class AddEndYearToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :end_year, :integer
  end

  def self.down
    remove_column :enrollments, :end_year
  end
end
