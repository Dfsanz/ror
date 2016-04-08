# == Schema Information
# Schema version: 5
#
# Table name: photos
#
#  id               :integer(11)   not null, primary key
#  photo_gallery_id :integer(11)   
#  image_link       :string(255)   
#  name             :string(255)   
#  description      :string(255)   
#  width            :integer(11)   
#  height           :integer(11)   
#  position         :integer(11)   
#

class Photo < ActiveRecord::Base
	belongs_to :photo_gallery	
	file_column :image_link, :magick => { 
      :versions => { "thumb" => "120x75", "medium" => "450x281", "full" => "800x500" }
    }	
end
