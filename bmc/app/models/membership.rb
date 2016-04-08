# == Schema Information
# Schema version: 8
#
# Table name: memberships
#
#  id          :integer(11)   not null, primary key
#  business_id :integer(11)   
#  category_id :integer(11)   
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Membership < ActiveRecord::Base
  belongs_to :category
  belongs_to :business
  
end
