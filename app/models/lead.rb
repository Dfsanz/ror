# == Schema Information
# Schema version: 8
#
# Table name: leads
#
#  id               :integer(11)   not null, primary key
#  first_name       :string(255)   
#  last_name        :string(255)   
#  email            :string(255)   
#  password         :string(255)   
#  phone            :string(255)   
#  address          :string(255)   
#  city             :string(255)   
#  state            :string(255)   
#  comments         :text          
#  additional_specs :text          
#  property_id      :integer(11)   
#  created_at       :datetime      
#  updated_at       :datetime      
#

class Lead < ActiveRecord::Base
  # attr_accessor :password_confirmation
  
  validates_presence_of     :first_name
  validates_presence_of     :last_name
  validates_presence_of     :email
  validates_presence_of     :phone
  # validates_presence_of     :password
  # validates_presence_of     :password_confirmation
  # validates_confirmation_of :password
  
end
