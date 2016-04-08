class AddCondoColumns < ActiveRecord::Migration
  def self.up
  	add_column :condos, :bedrooms, :string, :limit => 255
  	add_column :condos, :bathrooms, :string, :limit => 255
  	add_column :condos, :no_of_floors, :integer
  	add_column :condos, :no_of_units, :integer
  end

  def self.down  	
  	remove_column :condos, :bedrooms, :string, :limit => 255
  	remove_column :condos, :bathrooms, :string, :limit => 255
  	remove_column :condos, :no_of_floors, :integer
  	remove_column :condos, :no_of_units, :integer
  end
end
