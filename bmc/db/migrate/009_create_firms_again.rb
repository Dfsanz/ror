class CreateFirmsAgain < ActiveRecord::Migration
  def self.up
  	# create_table :firms do |table|
  		# table.column :mls_office_id, :string, :limit => 255
  		# table.column :tln_firm_id, :string, :limit => 255
  		# table.column :mls_office_name, :string, :limit => 255
  		# table.column :mls_office_phone, :string, :limit => 255		
  	# end
  end

  def self.down
  	drop_table :firms
  end
end
