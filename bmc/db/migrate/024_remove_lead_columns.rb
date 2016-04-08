class RemoveLeadColumns < ActiveRecord::Migration
  def self.up  	
  	remove_column :leads, :password
  	remove_column :leads, :address 
  	remove_column :leads, :city
  	remove_column :leads, :state 
  	remove_column :leads, :additional_specs
  	remove_column :leads, :property_id
  	add_column :leads, :unit_id, :int
  end

  def self.down
  end
end
