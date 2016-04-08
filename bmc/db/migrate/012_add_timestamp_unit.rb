class AddTimestampUnit < ActiveRecord::Migration
  def self.up
  	add_column :units, :created_at, :datetime  
  	add_column :units, :updated_at, :datetime
  end

  def self.down
  	remove_column :units, :created_at
  	remove_column :units, :updated_at
  end
end
