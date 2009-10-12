class CreateExtAdultContacts < ActiveRecord::Migration
  def self.up
    create_table :ext_adult_contacts do |t|
      t.belongs_to :student
      t.string :relationship
      t.boolean :guardian
      t.string :firstName
      t.string :lastName
      t.string :homePhone
      t.string :workPhone
      t.string :cellPhone
      t.string :pager
      t.string :email
      t.string :streetAddress
      t.string :cityStateZip

      t.timestamps
    end
  end

  def self.down
    drop_table :ext_adult_contacts
  end
end
