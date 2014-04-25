class AddMoreForeignKeyIndices < ActiveRecord::Migration
  def self.up
    add_index :flag_descriptions, :district_id
    add_index :countries, :abbrev
    add_index :team_consultations, :student_id
    add_index :consultation_forms, :team_consultation_id
    add_index :staff_assignments, [:school_id, :user_id]
    add_index :news_items, :system
    add_index :quicklist_items, [:district_id, :school_id]
  end

  def self.down
    remove_index :quicklist_items, column: [:district_id, :school_id]
    remove_index :news_items, column: :system
    remove_index :staff_assignments, column: [:school_id, :user_id]
    remove_index :consultation_forms, column: :team_consultation_id
    remove_index :team_consultations, column: :student_id
    remove_index :countries, column: :abbrev
    remove_index :flag_descriptions, column: :district_id
  end
end
