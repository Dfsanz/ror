class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :city
      t.integer :zipcode
      t.string :state
      t.string :country
      t.integer :category_id
      t.float :latitude
      t.float :longitude

      t.timestamps 
    end
  end

  def self.down
    drop_table :businesses
  end
end
