class Condo < ActiveRecord::Base
	include Cartographer::Geocode::Google
	
	has_many :units	
	file_column :main_image, :magick => { 
    :versions => { "thumb" => "100x129", "small" => "350x525", "medium" => "500x644" }}
	
	def to_json
		self.attributes.to_json
	end
	
	def icon
	  "condo"
  end
	
	def full_address
		"#{street_number} #{street_name}, #{city}, #{state}, #{zip_code}"
	end
	alias :address :full_address
end
