require 'open-uri'
require 'rexml/document'
# Retrieve geocode information for all records in the Stores table
task :google_geocode => :environment do
api_key="ABQIAAAAkhk94Ko6u4vxw8pCsnuUwRTJQa0g3IQ9GZqIMmInSLzwtGDKaBRxBSh4lU02_w9gTVH32L1OrMboaQ"
(Condo.find :all).each do |condo|
puts "\nCondo: #{condo.name}"
puts "Condo Address: #{condo.full_address}"
xml=open("http://maps.google.com/maps/geo?q=#{CGI.escape(condo.full_address)}&output=xml&key=#{api_key}").read
doc=REXML::Document.new(xml)
puts "Status: "+doc.elements['//kml/Response/Status/code'].text
if doc.elements['//kml/Response/Status/code'].text != '200'
puts "Unable to parse Google response for #{condo.name}"
else
doc.root.each_element('//Response') do |response|
response.each_element('//Placemark') do |place|
lng,lat=place.elements['//coordinates'].text.split(',')
puts "Result Address: " << place.elements['//address'].text
puts " Latitude: #{lat}"
puts " Longitude: #{lng}"
end # end each place
end # end each response
end # end if result == 200
end # end each store
end # end rake task