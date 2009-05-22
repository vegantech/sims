class CreateConsultationFormConcerns < ActiveRecord::Migration
  def self.up
    create_table :consultation_form_concerns do |t|
      t.integer :area
      t.belongs_to :consultation_form
      t.boolean :checked
      t.text :strengths
      t.text :concerns
      t.text :recent_changes

      t.timestamps
    end
  end

  def self.down
    drop_table :consultation_form_concerns
  end
end
