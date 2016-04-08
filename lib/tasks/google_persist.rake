task :google_persist => :environment do
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
lng,lat=doc.root.elements['//coordinates'].text.split(',')
condo.lat=lat
condo.lng=lng
condo.save
end # end if result == 200
end # end each condo
end # end rake task