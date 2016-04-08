class AddColumnFeaturedCondoWeight < ActiveRecord::Migration
  def self.up
  	add_column :condos, :featured_weight, :integer 
  end

  def self.down
  	remove_column :condos, :featured_weight
  end
end
