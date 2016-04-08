class AddColumnsUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :first_name, :string, :limit => 255
  	add_column :users, :last_name, :string, :limit => 255
  	add_column :users, :phone, :integer  	
  end

  def self.down
  	remove_column :users, :first_name, :string, :limit => 255
  	remove_column :users, :last_name, :string, :limit => 255
  	remove_column :users, :phone, :integer  	  	
  end
end
