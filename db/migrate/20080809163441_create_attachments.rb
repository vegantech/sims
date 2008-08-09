class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer :size
      t.string :content_type
      t.string :filename
      t.polymorphic :attachable
      t.integer :district_id

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
