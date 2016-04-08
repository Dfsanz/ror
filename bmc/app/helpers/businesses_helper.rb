module BusinessesHelper
  def render_map(map)
    unless map.markers.empty?
      html = content_tag(:div, '', :id => map.dom_id, :style => "width: #{map.width}px; height: #{map.height}px")
      html << map.to_html
      html
    end
  end
end
