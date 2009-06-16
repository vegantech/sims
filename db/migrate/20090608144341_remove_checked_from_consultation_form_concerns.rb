class RemoveCheckedFromConsultationFormConcerns < ActiveRecord::Migration
  def self.up
    remove_column :consultation_form_concerns,:checked
  end

  def self.down
    add_column :consultation_form_concerns,:checked, :boolean
  end
end
