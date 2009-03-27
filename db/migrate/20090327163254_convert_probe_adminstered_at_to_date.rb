class ConvertProbeAdminsteredAtToDate < ActiveRecord::Migration
  def self.up
    change_column :probes, :administered_at, :date
  end

  def self.down
    change_column :probes,:administered_at, :datetime
  end
end
