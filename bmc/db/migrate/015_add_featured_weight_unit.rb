class AddFeaturedWeightUnit < ActiveRecord::Migration
  def self.up
  	 	add_column :units, :mls_photos, :text
  	 	add_column :units, :featured_weight, :integer
  end

  def self.down
  	 remove_column :units, :mls_photos
  	 remove_column :units, :featured_weight
  end
end
