class CreateSchoolSpEdReferrals < ActiveRecord::Migration
  def change
    create_table :school_sp_ed_referrals do |t|
      t.belongs_to :school
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
