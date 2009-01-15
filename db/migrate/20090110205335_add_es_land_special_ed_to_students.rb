class AddEsLandSpecialEdToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :esl, :boolean
    add_column :students, :special_ed, :boolean
  end

  def self.down
    remove_column :students, :special_ed
    remove_column :students, :esl
  end
end
