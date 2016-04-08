# == Schema Information
# Schema version: 8
#
# Table name: business_photos
#
#  id           :integer(11)   not null, primary key
#  height       :integer(11)   
#  width        :integer(11)   
#  size         :integer(11)   
#  parent_id    :integer(11)   
#  content_type :string(255)   
#  filename     :string(255)   
#  thumbnail    :string(255)   
#  business_id  :integer(11)   
#  created_at   :datetime      
#  updated_at   :datetime      
#

class BusinessPhoto < ActiveRecord::Base
  
  belongs_to :business
  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :resize_to => '512x>',
                 :thumbnails => { :thumb => '60x60>'}
  
end
