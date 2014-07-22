class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :name
      t.string :url
      t.references :attachable, polymorphic: true
      t.timestamps
    end
    add_index :assets, [:attachable_id, :attachable_type]
    
  end

  def self.down
    remove_index :assets, column: [:attachable_id, :attachable_type]
    drop_table :assets
  end
end
