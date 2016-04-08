module RealEstateHelper
  def render_photo(photo, show_photo)
    attributes = {
      :id => "photo_id_#{photo.id}",
      :href => url_for_file_column(photo, 'image_link', 'full'), 
      :rel => "lightbox", 
      :title => photo.description
    }
    attributes[:style] = "display: none;" unless show_photo
    content_tag(:a, image_tag(url_for_file_column(photo, "image_link", "medium")), attributes)
  end
	
	def render_mls_photo(photo_url, show_photo, index)
  	attributes = {      
      :id => "photo_id_#{index}",
      :href => photo_url, 
      :rel => "lightbox"      
    }
    attributes[:style] = "display: none;" unless show_photo
  	content_tag(:a, image_tag(photo_url, :size => "421x281"), attributes)
	end
	
	def render_map(map)
		# debugger
    unless map.markers.empty?
      html = content_tag(:div, '', :id => map.dom_id, :style => "width: #{map.width}px; height: #{map.height}px")
      html << map.to_html
      html
    end
  end
end
