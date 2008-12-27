class AddAttachmentsLogoToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :logo_file_name, :string
    add_column :districts, :logo_content_type, :string
    add_column :districts, :logo_file_size, :integer
    add_column :districts, :logo_updated_at, :datetime
  end

  def self.down
    remove_column :districts, :logo_file_name
    remove_column :districts, :logo_content_type
    remove_column :districts, :logo_file_size
    remove_column :districts, :logo_updated_at
  end
end
