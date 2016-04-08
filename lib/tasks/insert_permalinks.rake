task :insert_permalinks => :environment do
	condos = Condo.find(:all)
	units = Unit.find(:all)
	
	# for condo in condos		
		# permalink = condo.name.downcase.gsub(' ','-')		
		# puts permalink
		# Condo.update(condo.id, {:permalink => permalink})
		# Person.update(15, {:user_name => 'Samuel', :group => 'expert'})	
	# end
	
	count = 0
	
	for unit in units
		save_permalink = true
		condo = Condo.find_by_id(unit.condo_id)		
		permalink_unit = condo.street_number.strip << '-' << condo.street_name.strip.downcase.gsub(' ','-') << '-' << 'unit-' << unit.unit_number.strip.gsub(' ','-')
		
		if(save_permalink)
			count += 1
			puts permalink_unit
			Unit.update(unit.id, {:permalink_unit => permalink_unit})		
			puts count
		end					
		
		# If the unit_number field is empty or set to zero then we save the autogenerate id #
		if(unit.unit_number.strip == '0'|| unit.unit_number.strip.length == 0)
			permalink_unit = condo.street_number.strip << '-' << condo.street_name.strip.downcase.gsub(' ','-') << '-' << 'uid' << unit.id.to_s
			Unit.update(unit.id, {:permalink_unit => permalink_unit})					
			puts "unit number is zero, saving modified permalink"
			save_permalink = false
		else
			permalink_unit = condo.street_number.strip << '-' << condo.street_name.strip.downcase.gsub(' ','-') << '-' << 'unit-' << unit.unit_number.strip.gsub(' ','-')
			permalink_exists = false
			
			# If the permalink already exists for this permalink then we do not modify
			for unit in units
				if (unit.permalink_unit	== permalink_unit)
					puts "permalink exists, not saving"
					save_permalink = false
					break
				end			
			end							
		end	
	end		
end