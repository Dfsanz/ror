class RenameCondosColumns < ActiveRecord::Migration
  def self.up  	
  	rename_column :condos, :bedrooms, :beds
  	rename_column :condos, :bathrooms, :baths
  end

  def self.down
  end
end
