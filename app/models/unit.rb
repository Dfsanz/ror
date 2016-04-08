# == Schema Information
# Schema version: 8
#
# Table name: units
#
#  id             :integer(11)   default(0), not null, primary key
#  mls_listing_id :string(255)   
#  unit_number    :integer(11)   
#  price          :integer(11)   
#  bedrooms       :integer(255)  
#  bathrooms      :integer(255)  
#  feature_codes  :text          
#  sale_or_rent   :string(255)   
#  description    :text          
#  square_footage :integer(11)   
#  taxes          :string(255)   
#  tax_year       :string(255)   
#  condo_id       :integer(11)   
#  agent_id       :integer(11)   
#  firm_id        :integer(11)   
#  permalink_unit :string(255)   
#

class Unit < ActiveRecord::Base
	belongs_to :condo	
	belongs_to :agent
	belongs_to :firm	
	has_many :photo_galleries
end
