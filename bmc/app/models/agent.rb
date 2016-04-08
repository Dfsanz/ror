# == Schema Information
# Schema version: 8
#
# Table name: agents
#
#  id              :integer(11)   not null, primary key
#  mls_agent_id    :string(255)   
#  mls_agent_name  :string(255)   
#  mls_agent_phone :string(255)   
#  firm_id         :integer(11)   
#

class Agent < ActiveRecord::Base
	has_many :units
	has_one :firm
	
end
