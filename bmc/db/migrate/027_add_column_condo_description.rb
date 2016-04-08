class AddColumnCondoDescription < ActiveRecord::Migration
  def self.up
  	add_column :condos, :description, :string
  end

  def self.down
  	remove_column :condos, :description
  end
end
