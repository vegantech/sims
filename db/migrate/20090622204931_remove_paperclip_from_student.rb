class RemovePaperclipFromStudent < ActiveRecord::Migration
  def self.up
    remove_column :students, :extended_profile_file_name
    remove_column :students, :extended_profile_content_type
    remove_column :students, :extended_profile_file_size
    remove_column :students, :extended_profile_updated_at
  end
  def self.down
    add_column :students, :extended_profile_file_name, :string
    add_column :students, :extended_profile_content_type, :string
    add_column :students, :extended_profile_file_size, :integer
    add_column :students, :extended_profile_updated_at, :datetime
  end
end
