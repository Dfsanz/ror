class AddColumnActiveUnit < ActiveRecord::Migration
  def self.up
  	add_column :units, :active, :boolean
  end

  def self.down
  	 remove_column :units, :active
  end
end
