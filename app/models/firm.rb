# == Schema Information
# Schema version: 8
#
# Table name: firms
#
#  id               :integer(11)   not null, primary key
#  mls_office_id    :string(255)   
#  tln_firm_id      :string(255)   
#  mls_office_name  :string(255)   
#  mls_office_phone :string(255)   
#

class Firm < ActiveRecord::Base
	has_many :agents
	has_many :units
end
