class AddFlashCondoColumn < ActiveRecord::Migration
  def self.up
  	add_column :condos, :flash, :boolean
  end

  def self.down
  	remove_column :condos, :flash
  end
end
