class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.binary :passwordhash
      t.string :first_name
      t.string :last_name
      t.belongs_to :district 

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
