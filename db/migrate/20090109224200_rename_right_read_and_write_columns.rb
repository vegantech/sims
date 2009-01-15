class RenameRightReadAndWriteColumns < ActiveRecord::Migration
  def self.up
    rename_column :rights, :read, :read_access
    rename_column :rights, :write, :write_access
  end

  def self.down
    rename_column :rights, :write_access, :write
    rename_column :rights, :read_access, :read
  end
end
