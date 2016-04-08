# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def remove_cdata_tag(string)			
		string.gsub(/<!\[CDATA\[|\]\]>|\[\.\.\.\]/,"")
  end
	
	def thumb_for photo
		url = thumb_photo_url(:album_id => photo.album_id, :id => photo)
		image = image_tag(url, :class => "thumb", :alt => "")
		link_to_function image, nil, :class => "show" do |page|
			page.photo.show medium_photo_url(:album_id => photo.album_id,
				:id => photo)
		end
	end
	
	def toggle_edit_photo id
		page.toggle "#{id}_name", "#{id}_edit", "#{id}_delete"
	end
	
	def breadcrumbs
	  r = []	  
	  r << content_tag("li", link_to("Home", "/"))
	  url = request.path.split('?')
	  segments = url[0].split('/')
	  segments.shift
	  segments.each_with_index do |segment, i|
	    title = segment.gsub(/-/, ' ').titleize
	    r << content_tag("li", link_to_unless_current(title, "/" + 
	         (0..(i)).collect{|seg| segments[seg]}.join("/")))
	  end
	  return content_tag("div", content_tag("ul", r.join(" &#187; ")), 
	         :class => "breadCrumb")
	end
	
	

	def url_unescape(string)
		string.gsub!(/%2F/, '/')	
		string.gsub!(/redirect=/, '')		
	end

end
