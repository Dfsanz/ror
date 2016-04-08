class CreateLeads < ActiveRecord::Migration
  def self.up
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :phone
      t.string :address
      t.string :city
      t.string :state
      t.text :comments
      t.text :additional_specs
      t.integer :property_id
      t.timestamps
    end
  end

  def self.down
    drop_table :leads
  end
end
