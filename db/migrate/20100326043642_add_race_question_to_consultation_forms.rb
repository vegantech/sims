class AddRaceQuestionToConsultationForms < ActiveRecord::Migration
  def self.up
    add_column :consultation_forms, :race_culture, :text
  end

  def self.down
    remove_column :consultation_forms, :race_culture
  end
end
