class CreateExtArbitraries < ActiveRecord::Migration
  def self.up
    create_table :ext_arbitraries do |t|
      t.belongs_to :student
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :ext_arbitraries
  end
end
