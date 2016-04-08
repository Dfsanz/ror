class AddDescriptionToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :description, :text  
    add_column :businesses, :phone, :string  
    add_column :businesses, :url, :string  
    add_column :businesses, :fax, :string  
    add_column :businesses, :email, :string  
  end

  def self.down
    remove_column :businesses, :email  
    remove_column :businesses, :fax  
    remove_column :businesses, :url  
    remove_column :businesses, :phone  
    remove_column :businesses, :description  
  end
end
