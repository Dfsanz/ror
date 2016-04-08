task :import_sefl_data => :environment do
		@count=0
		@street_no =""
		@condo_id =""
		zip_codes = ["33129","33130","33131", "33132"]			
	  condos=Condo.find_by_sql "SELECT street_number, street_name, id FROM condos"											 											 
		input_file = 'lib/sefl_data/sefl_data.txt'
		output_file = 'lib/sefl_data/condo_units.csv'
		out = File.new(output_file, "w")
		units = Unit.find(:all)
		
		# Iterate through each record in unit table and set to inactive
# 		for unit in units
# 			Unit.update(unit.id, {:active => 0})			
# 		end
		
		for_rent = 0
		for_sale = 0	
		
		for_rent_o = 0
		for_sale_o = 0	
		
		# Iterate through each line the the sefl_data txt fileta
		IO.foreach(input_file) do |line|	
			for zip in zip_codes
			# Check each line for the existance of each of the qualifying zip codes	
				if line.include? zip
					# If a qualifying zip, then we split the line and check the street number
					modified_line = line.gsub(/","/, '"*"')			
					columns = modified_line.split('*')						
					# For each condo street number in our condos table we check if we find a match
					for condo in condos						
						condo_street_no = columns.values_at(20).to_s.gsub(/\"/,"")
						property_type_code = columns[13].to_s.gsub(/\"/,"").strip
						
						
												
						# Iterates through each row in condo table and checks against row in sefl_data.txt
						if condo_street_no.strip == condo.street_number.to_s.strip
							if property_type_code == "R"	|| property_type_code == "M" 					
								for_rent_o += 1
							
								for_sale_o += 1
							else								
							end 
						end
						
						if condo_street_no.strip == condo.street_number.to_s.strip && (property_type_code == "M" || property_type_code == "R" ) 			
						puts "unit should be set to active in dbase"									
# 							# We have found a match for a building
# 							# If a match is found we save it to our database table							
# 							# Value 88 now contains the condos id
							out.puts columns.values_at(2,3,4,5,6,7,8,13,15,17,20,21,23,24,29,34,36,41,42,43,61,62,84,85,86,87,88,89).join(',')														
							@count+=1	
							for_rent += 1
							for_sale += 1
							
							# Set Values
							mls_listing_id = columns[2].to_s.gsub(/\"/,"").strip
							tln_firm_id = columns[3].to_s.gsub(/\"/,"").strip
							mls_office_name = columns[4].to_s.gsub(/\"/,"").strip
							mls_office_phone = columns[5].to_s.gsub(/\"/,"").strip
							mls_agent_name = columns[7].to_s.gsub(/\"/,"").strip
							mls_agent_phone = columns[8].to_s.gsub(/\"/,"").strip							
							description = columns[15].to_s.gsub(/\"/,"").strip
							price = columns[17].to_s.gsub(/\"/,"").strip
							unit_number = columns[24].to_s.gsub(/\"/,"").strip
							year_built = columns[36].to_s.gsub(/\"/,"").strip
							square_footage = columns[41].to_s.gsub(/\"/,"").strip
							bedrooms = columns[42].to_s.gsub(/\"/,"").strip
							bathrooms = columns[43].to_s.gsub(/\"/,"").strip
							taxes = columns[61].to_s.gsub(/\"/,"").strip
							tax_year = columns[62].to_s.gsub(/\"/,"").strip		
							feature_codes = columns[84].to_s.gsub(/\"/,"").strip							
							mls_office_id = columns[85].to_s.gsub(/\"/,"").strip								
							mls_agent_id = columns[86].to_s.gsub(/\"/,"").strip
							mls_photo_quantity = columns[88].to_s.gsub(/\"/,"").strip
							mls_main_photo_url = columns[89].to_s.gsub(/\"/,"").strip
							photo_list = ""
							
							# Populate the photo_list variable with comma seperated list of listing photos
							if(mls_photo_quantity != '0'&& mls_photo_quantity.length != 0)
								# puts mls_photo_quantity.to_i
								# puts mls_main_photo_url
								
								photo_list = mls_main_photo_url
								
								if (mls_photo_quantity.to_i > 1 && mls_photo_quantity.to_i < 100)  
									for i in 1...mls_photo_quantity.strip.to_i
	 									# Create photo urls for 1 through N photos
	 									photo_no = i + 1
	 									photo_n = mls_main_photo_url.sub(/.jpg/, '_' << photo_no.to_s << '.jpg')
	 									photo_list = photo_list + ',' + photo_n
	 									# puts photo_n
	 								end
	 							end						  
						  end
						  
						  # puts photo_list
# 							
# 							
# 							# COMMENT OUT COMMENT OUT
# # 							Condo.update(condo.id,{
# # 										:year_built => year_built.strip.to_i
# # 																			})						
							
							if(property_type_code == "R")							
								sale_or_rent = "Rent"																					
							else
								sale_or_rent = "Sale"								
							end							
# 						
# # >>>>>>>>>>>>>>>>>>>>>>>>>>> Update Firm Begin <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
																					
						if !Firm.exists?(:mls_office_id => mls_office_id)
								puts "FIRM DOES NOT EXIST"								
								Firm.create(
										:mls_office_id => mls_office_id,
										:tln_firm_id => tln_firm_id,
										:mls_office_name => mls_office_name,
										:mls_office_phone => mls_office_phone)
								
							else
								update_firm = false
								puts "FIRM EXISTS"		
								# Find firm from database and determine if any info has changed, if changed info then update						
								firm = Firm.find(:first, :conditions => ["mls_office_id = ?",mls_office_id])									
								if firm.mls_office_id.strip != mls_office_id
										puts "MLS Office ID CHANGED"									
										update_firm = true
									elsif firm.tln_firm_id.strip != tln_firm_id
										puts "MLS TLN Firm ID CHANGED"
										update_firm = true
									elsif firm.mls_office_name.strip != mls_office_name
										puts "MLS Office Name CHANGED"
										update_firm = true
									elsif firm.mls_office_phone.strip != mls_office_phone
										puts "MLS Office Phone CHANGED"
										update_firm = true
								end
								
								if update_firm
									puts "Update firm info"
									Firm.update(firm.id,{
										:mls_office_id => mls_office_id,
										:tln_firm_id => tln_firm_id,
										:mls_office_name => mls_office_name,
										:mls_office_phone => mls_office_phone										
																			})										
								end								
							end							
							
# # >>>>>>>>>>>>>>>>>>>>>>>>>>> Update Firm End <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<			
							
							# Find firm_id							
							temp_id = Firm.find_by_sql ["SELECT id FROM firms WHERE mls_office_id = ?", mls_office_id]							
 							@temp_firm_id = Firm.find_by_mls_office_id(mls_office_id) 							
 							puts "@temp_firm_id: " << @temp_firm_id.to_s 							
 							firm_id = @temp_firm_id.id								
							puts "firm_id: " << firm_id.to_s														
							
# # >>>>>>>>>>>>>>>>>>>>>>>>>>> Update Agent Begin <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
							
							if !Agent.exists?(:mls_agent_id => mls_agent_id)
								puts "AGENT DOES NOT EXIST"
								Agent.create(
										:mls_agent_id => mls_agent_id,
										:mls_agent_name => mls_agent_name,
										:mls_agent_phone => mls_agent_phone,
										:firm_id => firm_id)
							else
								puts "AGENT EXISTS"								
								update_agent = false								
								# Find Agent from database and determine if any info has changed, if changed info then update						
								agent = Agent.find(:first, :conditions => ["mls_agent_id = ?",mls_agent_id])									
								if agent.mls_agent_name.strip != mls_agent_name
										puts "MLS Agent Name CHANGED"									
										update_agent = true
									elsif agent.mls_agent_phone.strip != mls_agent_phone
										puts "MLS Agent Phone CHANGED"
										update_agent = true
									elsif agent.firm_id.to_s.strip != firm_id
										puts "Agent Firm ID CHANGED"
										update_agent = true									
								end
								
								if update_agent
									puts "Update agent info"
									Agent.update(agent.id,{
										:mls_agent_id => mls_agent_id,
										:mls_agent_name => mls_agent_name,
										:mls_agent_phone => mls_agent_phone,
										:firm_id => firm_id									
																			})										
								end
							end
							
# # >>>>>>>>>>>>>>>>>>>>>>>>>>> Update Agent End <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<							

							# Find agent_id
							@temp_agent_id = Agent.find_by_mls_agent_id(mls_agent_id)
							agent_id = @temp_agent_id.id 		
							puts "agent_id: " << agent_id.to_s		

# >>>>>>>>>>>>>>>>>>>>>>>>>>> Update Unit Begin <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<							
	 							
	 							# Generate permalink
 								if(unit_number.strip == '0'|| unit_number.strip.length == 0)
									permalink_unit = condo.street_number.to_s.strip << '-' << condo.street_name.to_s.strip.downcase.gsub(' ','-') << '-' << 'mls-' << mls_listing_id
								else
 									permalink_unit = condo.street_number.to_s.strip << '-' << condo.street_name.to_s.strip.downcase.gsub(' ','-') << '-' << 'unit-' << unit_number.strip.gsub(' ','-')
 								end											
 								
 								puts permalink_unit 
							
 							if !Unit.exists?(:mls_listing_id => columns[2].to_s.gsub(/\"/,""))
 								puts "UNIT DOES NOT EXIST" 																					
 								
								Unit.create(
										:mls_listing_id =>columns[2].to_s.gsub(/\"/,""),
										:unit_number =>columns[24].to_s.gsub(/\"/,""),
										:price =>columns[17].to_s.gsub(/\"/,""),
										:bedrooms =>columns[42].to_s.gsub(/\"/,""),
										:bathrooms =>columns[43].to_s.gsub(/\"/,""),
										:feature_codes =>columns[84].to_s.gsub(/\"/,""),
										:sale_or_rent =>sale_or_rent,
										:description =>columns[15].to_s.gsub(/\"/,""),
										:square_footage =>columns[41].to_s.gsub(/\"/,""),
										:taxes =>columns[61].to_s.gsub(/\"/,""),
										:tax_year =>columns[62].to_s.gsub(/\"/,""),
										:condo_id =>condo.id,
										:agent_id => agent_id,
										:firm_id => firm_id,
										:permalink_unit => permalink_unit,
										:mls_photos => photo_list,
										:active => 1 
												)
							puts "Created unit and set to active"
 							else								
 									puts "UNIT EXISTS"	
 									puts "Setting to active and updating other fields"
 									update_unit = false
 									unit = Unit.find(:first, :conditions => ["mls_listing_id = ?",mls_listing_id])
 																		 									
 									if unit.unit_number.to_s.strip != unit_number
										# Each of these if statments would generate a create in the unit_updates table
										# Each entry in the unit_updates table would correspond to a change to a field in the mls# for a property
										# User alerts would be triggered by these changes
										puts "Unit Number CHANGED"									
										update_unit = true
									elsif unit.price.to_s.strip != price
										puts "Price CHANGED"
										update_unit = true
									elsif unit.bedrooms.to_s.strip != bedrooms
										puts "Bedrooms CHANGED"
										update_unit = true									
									elsif unit.bathrooms.to_s.strip != bathrooms
										puts "Bathrooms CHANGED"
										update_unit = true									
									elsif unit.feature_codes.strip != feature_codes
										puts "Feature Codes CHANGED"
										update_unit = true									
									elsif unit.sale_or_rent.strip != sale_or_rent
										puts "Sale or Rent CHANGED"
										update_unit = true									
									elsif unit.description.strip != description
										puts "Description CHANGED"
										update_unit = true									
									elsif unit.square_footage.to_s.strip != square_footage
										puts "Square Footage CHANGED"
										update_unit = true									
									elsif unit.taxes.strip != taxes
										puts "Taxes CHANGED"
										update_unit = true									
									elsif tax_year.strip != tax_year
										puts "Tax Year CHANGED"
										update_unit = true						
									elsif unit.agent_id.to_s.strip != agent_id
										puts "Agent CHANGED"
										update_unit = true						
									elsif unit.firm_id.to_s.strip != firm_id
										puts "Firm CHANGED"
										update_unit = true	
							end		
							puts photo_list
							Unit.update(unit.id, {
										:mls_listing_id =>columns[2].to_s.gsub(/\"/,""),
										:unit_number =>columns[24].to_s.gsub(/\"/,""),
										:price =>columns[17].to_s.gsub(/\"/,""),
										:bedrooms =>columns[42].to_s.gsub(/\"/,""),
										:bathrooms =>columns[43].to_s.gsub(/\"/,""),
										:feature_codes =>columns[84].to_s.gsub(/\"/,""),
										:sale_or_rent =>sale_or_rent,
										:description =>columns[15].to_s.gsub(/\"/,""),
										:square_footage =>columns[41].to_s.gsub(/\"/,""),
										:taxes =>columns[61].to_s.gsub(/\"/,""),
										:tax_year =>columns[62].to_s.gsub(/\"/,""),
										:condo_id =>condo.id,
										:agent_id => agent_id,
										:firm_id => firm_id,
										:permalink_unit => permalink_unit,
										:mls_photos => photo_list,
										:active => 1 
											})																		
# # 									# If Unit exists, we check to see if it has changed.  If it has, then we update record and enter new update date
# # 									# unit = Unit.find(:first, :conditions => ["mls_listing_id = ?","D1170185"])									
 								end														
							break
						end # if condo_street_no.strip == condo.street_number.to_s.strip && property_type_code == ( "M" || "R" ) 			
					end	# for condo in condos
					break	# if we've processesd the unit then we break out of the zip code check				
				end	# if line.include? zip
			end # for zip in zip_codes
		end # IO.foreach(input_file) do |line|	
		
		puts "for_rent " << for_rent.to_s
		puts "for_sale " << for_sale.to_s
		puts "for_rent_o " << for_rent_o.to_s
		puts "for_sale_o " << for_sale_o.to_s
		
		puts "Counted " << @count.to_s << " condos"
		out.close		
end # task :import_sefl_data => :environment do