# == Schema Information
# Schema version: 8
#
# Table name: unit_feature_codes
#
#  id                  :integer(11)   default(0), not null, primary key
#  feature_type        :string(255)   
#  feature_code        :string(255)   
#  feature_description :string(255)   
#

class UnitFeatureCode < ActiveRecord::Base
end
