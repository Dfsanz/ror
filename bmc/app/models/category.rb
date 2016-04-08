# == Schema Information
# Schema version: 8
#
# Table name: categories
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#  parent_id  :integer(11)   
#  icon       :string(255)   
#

class Category < ActiveRecord::Base
  has_many :businesses, 
  :finder_sql => 'SELECT * FROM categories JOIN memberships ON memberships.category_id = categories.id JOIN businesses ON memberships.business_id = businesses.id WHERE parent_id = #{id} OR categories.id = #{id} GROUP BY businesses.id'
  scope_out :parents, :conditions => ["parent_id is NULL"]
  scope_out :children, :conditions => ["parent_id is not NULL"]
  seo_urls "name"
  
  def self.icons
    [["bar", "http://maps.google.com/mapfiles/kml/pal2/icon27"],
     ["condo", "http://maps.google.com/mapfiles/kml/pal3/icon21"],
     ["restaurant", "http://maps.google.com/mapfiles/kml/pal2/icon32"],
     ["hotel", "http://maps.google.com/mapfiles/kml/pal2/icon20"],
     ["market", "http://maps.google.com/mapfiles/kml/pal3/icon18"],
     ["train", "http://maps.google.com/mapfiles/ms/micons/tram"],
     ["cafe", "http://maps.google.com/mapfiles/kml/pal2/icon54"]	 
    ]
  end
  
  def self.icon_list
    icons.collect {|i| [i[0], i[0]]}
  end
  
  def parent
    parent_id ? Category.find(parent_id) : nil
  end
  
  def children
    Category.find(:all, :conditions => ["parent_id = ?", id ] )
  end
  
end
