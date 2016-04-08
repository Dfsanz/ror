# == Schema Information
# Schema version: 8
#
# Table name: businesses
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  address     :string(255)   
#  city        :string(255)   
#  zipcode     :integer(11)   
#  state       :string(255)   
#  country     :string(255)   
#  category_id :integer(11)   
#  latitude    :float         
#  longitude   :float         
#  created_at  :datetime      
#  updated_at  :datetime      
#  description :text          
#  phone       :string(255)   
#  url         :string(255)   
#  fax         :string(255)   
#  email       :string(255)   
#

class Business < ActiveRecord::Base
  include Cartographer::Geocode::Google
  
  has_one :business_photo
  has_many :memberships, :dependent => :destroy
  has_many :categories, :through => :memberships
  
  seo_urls "name"
  
  before_save :geocoding
  
  acts_as_indexed :fields => [:name, :address, :city, :zipcode, :state, :category_names, :phone, :url, :fax]
  
  def full_address
    "#{address} \n #{city}, #{state} #{zipcode}"
  end
  
  def icon
    categories.first.icon
  end
  
  def category_names
    self.categories.collect(&:name)
  end
  
  def category_ids=(category_ids)
    memberships.each do |m|
      m.destroy unless category_ids.include? m.category_id
    end

    category_ids.each do |c_id|
      self.memberships.build(:category_id => c_id) unless memberships.any? { |m| m.category_id == c_id }
    end
  end
  
  def address_query
    # 1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA
    [self.address, self.city, "#{self.state} #{self.zipcode}", self.country].collect { |s| to_query(s) }.compact.join(',')
  end
  
  def geocoding
    coordinates = geocode(address_query)
    self.latitude = coordinates[:latitude]
    self.longitude = coordinates[:longitude]
  end
  
  private
  
    def to_query(str)
      return nil if str.strip.blank?
      str.gsub(/\s/, '+')
    end
end
