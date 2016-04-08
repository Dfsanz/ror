# == Schema Information
# Schema version: 8
#
# Table name: photo_galleries
#
#  id                    :integer(11)   not null, primary key
#  unit_id               :integer(11)   
#  photo_gallery_type_id :integer(11)   
#

class PhotoGallery < ActiveRecord::Base
	belongs_to :unit	
	belongs_to :photo_gallery_type
	has_many :photos, :order => "position"
end
