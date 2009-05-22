class CreateConsultationForms < ActiveRecord::Migration
  def self.up
    create_table :consultation_forms do |t|
      t.belongs_to :user
      t.belongs_to :team_consultation
      t.text :do_differently
      t.text :parent_notified
      t.text :not_in_sims
      t.text :desired_outcome

      t.timestamps
    end
  end

  def self.down
    drop_table :consultation_forms
  end
end
