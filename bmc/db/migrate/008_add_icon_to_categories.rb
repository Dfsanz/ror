class AddIconToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :icon, :string  
  end

  def self.down
    remove_column :categories, :icon  
  end
end
