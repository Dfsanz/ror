class RealEstateController < ApplicationController
	before_filter :setup_map, :only => [ :show, :unit ]
	caches_page :index, :unit, :show
	cache_sweeper :site_sweeper, :only => [:create, :update, :destroy]	
	#text-link-ads code
	require 'net/http'
	require 'cgi'		
	
	def index
		  @condo_pages, @condos = paginate :condos, :per_page => 200, :order_by => 'main_image DESC'
		  @condo_tab = "currentTab"		  
		  @page_title = "Brickell Ave Condos and Brickell Key Condos for Sale and Rent"
		  # Initialize variable needed for partial: _price_boundaries.rhtml
			@value_name_collection = load_value_name_collection("")
			@pages = @condo_pages			
    	# Notifier::deliver_multipart_alternative("dsanz@sanzconsulting.com", "Diego")  
    	@real_estate_ui_display = "display: block"
	end
		
	def home				
		# @doc = Hpricot.XML(open("http://brickellmiamicondos.com/en/feed/")) 		
		@page_title = "Brickell Miami Condos, Brickell Key Condos and Downtown Miami Real Estate"		
		@home_tab = "currentTab"							
		@featured_condos = Condo.find(:all, :conditions => ['featured_weight != ?', 0], :order => 'name ASC')
		# Initialize variable needed for partial: _price_boundaries.rhtml
		@value_name_collection = load_value_name_collection("")	  
		@real_estate_ui_display = "display: none"
	end
	
  def rentals			  
  	@condo_tab = "currentTab"	    
    @page_title = "Brickell Rentals and Brickell Key Apartments, Downtown Miami Condos for Rent"   
		@value_name_collection = load_value_name_collection("")	   			
		
	  if params[:sort_by].nil?		
			order = 'featured_weight ASC'
		elsif params[:sort_by] == "square-footage"							
				order = 'square_footage ASC'							
		elsif params[:sort_by] == "price"
			order = 'price ASC'
		elsif params[:sort_by] == "bedrooms"
			order = 'bedrooms ASC'		
	  end
			
		@unit_pages = Unit.paginate(:conditions => { :sale_or_rent => "rent", :active => "1" }, :order => order,			
			:per_page => 40,
			:page => params[:page])	
		
	end
	
	def units		
  	@unit_pages, @units = paginate :units, 
  												:conditions => ["units.condo_id=?", params[:id]],
  												:per_page => 200  	
 	end
	
	def unit		
		set_user_values(logged_in_user)									
		@condo_tab = "currentTab"												
		@unit = Unit.find_by_permalink_unit(params[:permalink_unit])	
    @map.width = 320
		@map.height = 331
		@icons = icons
    add_condo_to_map(@unit.condo, @map)		
		@page_title = @unit.condo.name + " : " + @unit.condo.street_number + " " + @unit.condo.street_name + " : Unit " + @unit.unit_number.to_s		
		fc = @unit.feature_codes.split(',')
		@feature_codes = UnitFeatureCode.find(:all, :conditions => ["feature_code IN (?)", fc])		
		
		# If featured listing then load fully featured photo gallery else load mls photo gallery
		if @unit.featured_weight > 0
			@photo_galleries = PhotoGallery.find(:all, :conditions => [ "unit_id IN (?)", @unit.id])	
			@photo_gallery_thumbnails = @photo_galleries[0]				
		else
			if !@unit.mls_photos.nil?
				@mls_photos = @unit.mls_photos.split(',')
			else
				@mls_photos = ["http://extimages2.living.net/ImagesHomeProd6/FL/idx/photos/miamimls/07/D1170669.jpg"]
			end
		end	
		

	
		
		# From new action in leads controller		
		unit_id = params[:unit_id]
    @lead = Lead.new
    @lead.unit_id = unit_id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lead }
    end
		
	end
	
	def change_photo_gallery		
		@photo_gallery = PhotoGallery.find(params[:id])
	end	
	
	def update_photo_main
		@photo_main = Photo.find(params[:id])		
		# render :text => "<a href='/photo/image_link/38/full/152096340_5a91156b83_o.jpg' rel='lightbox' title='Building Exterior 1'><img alt='152096340_5a91156b83_o' src='/photo/image_link/38/medium/152096340_5a91156b83_o.jpg?1183156205' /></a>"
		render :partial => "photo_main"		
	end
			
	def search	
		@condo_tab = "currentTab"		
		if params[:unit].nil?			
			params[:unit] = session[:search_params]
			params[:unit].merge!("sort_by" => params[:sort_by].to_s)			
		else				
			session[:search_params] = params[:unit]			
			params[:unit].merge!("sort_by" => "")
		end			
		
		sql_string = search_sql_string(params[:unit])	
		count_sql_string = sql_string.gsub('SELECT *', 'SELECT COUNT(*)')		
		
		@page_title = "Brickell Miami Condos : Real Estate : Search"
		@condo_id = params[:unit][:condo_id].to_i
		@price_lower = params[:unit][:price_lower].to_i
		@price_upper = params[:unit][:price_upper].to_i
		@bedrooms = params[:unit][:bedrooms].to_i
		@bathrooms = params[:unit][:bathrooms].to_i		
		@sale_or_rent = params[:unit][:sale_or_rent].to_s				
	  @value_name_collection = load_value_name_collection(params[:unit][:sale_or_rent])
	  @price_upper = params[:unit][:price_upper].to_i		
	  @price_lower = params[:unit][:price_lower].to_i	  	  
		paginate_from_sql(Unit, sql_string, count_sql_string, 100)   		
		@real_estate_ui_display = "display: block"
	end
	
	def get_price_boundaries										
		@value_name_collection = load_value_name_collection(params[:sale_or_rent])
		render :partial => "price_boundaries", :locals => { :price_boundaries => @value_name_collection }
	end
	
	def show				
		@condo_tab = "currentTab"	
    @condo = Condo.find_by_permalink_condo(params[:permalink_condo])  
    @condo_id = @condo.id.to_i
    @map.width = 354
		@map.height = 377
		@icons = icons
    add_condo_to_map(@condo, @map)
    @page_title = @condo.name + " Condo : " + @condo.street_number + " " + @condo.street_name    
    @condo_gallery_flash_path = "http://www.brickellmiamicondos.com/flash/condo_id_"+ @condo.id.to_s + "_slideshow.swf"
    # @units = Unit.find_all_by_condo_id(@condo.id)
    @units = Unit.find(:all, :conditions => ["condo_id = :cid AND active = 1",{:cid => @condo.id}])
    # .find(:all, :conditions => [ "unit_id IN (?)", @unit.id])	
    # Initialize variable needed for partial: _price_boundaries.rhtml
		@value_name_collection = load_value_name_collection("")	  
  end
  
  private   
  def load_value_name_collection(sale_or_rent)
  	if sale_or_rent == "sale"					
			value_name_collection = [['$100,000',100000], ['$200,000',200000], ['$300,000',300000], ['$400,000',400000], ['$500,000',500000], ['$600,000',600000], ['$700,000',700000], ['$800,000',800000], ['$900,000',900000], ['$1,000,000',1000000]]  				
		elsif sale_or_rent == "rent"					
			value_name_collection = [['$500',500], ['$1,000',1000], ['$1,500',1500], ['$2,000',2000], ['$2,500',2500], ['$3,000',3000], ['$3,500',3500], ['$4,000',4000], ['$4,500',4500], ['$5,000',5000]] 
		else
			value_name_collection = ""
		end
	end
    
  def load_data
      @condos = Condo.find(:all)
      @firms = Firm.find(:all)
      @agents = Agent.find(:all)
  end
    
  def paginate_from_sql(model, sql, count_sql, per_page)    	
      plural_model_name = "@#{model.name.underscore.pluralize}".to_sym			    
			paginator_name = "@#{model.name.underscore}_pages".to_sym       			 			
			@no_records_returned = model.count_by_sql(count_sql)
			@pages = self.instance_variable_set(paginator_name, Paginator.new(self, @no_records_returned, per_page, params[:page]))
			self.instance_variable_set(plural_model_name, model.find_by_sql(sql + " LIMIT #{per_page}" + " OFFSET #{self.instance_variable_get(paginator_name).current.to_sql[1]}"))            
	end
   
  def set_user_values(user)		
		if user.nil?
			@first_name = ""
			@last_name = ""
			@username = ""
			@phone = ""			
	else
			@first_name = user.first_name
			@last_name = user.last_name
			@username = user.username
			@phone = user.phone			
		end
  end
   
   def setup_map
		@map = Cartographer::Gmap.new(:name => 'condoMap')
    @map.autocenter = true    
    @map.controls << :zoom
    @map.controls << :large
    @map.controls << :type       
    @map.zoom = 16
    @map.ewindow_control = 'ew'
  end
  
  def add_condo_to_map(condo, map)
      info_window = render_to_string :partial => 'info_window', :locals => { :condo => condo }
      info_window.gsub!(/"/, '\\"')
      
      marker_name = "marker_#{condo.class.to_s.downcase}_#{condo.id}"
      map.markers << Cartographer::Gmarker.new({
            :position => [condo.latitude.to_f, condo.longitude.to_f], 
            :info_window => info_window,
            :map => map,
            :name => marker_name,
            :icon => condo.icon,
            :click => "#{@map.dom_id}.panTo(new GLatLng(#{condo.latitude.to_f}, #{condo.longitude.to_f})); #{map.ewindow_control}.openOnMarker(#{marker_name}, \"#{info_window}\")"
      }) if condo.latitude && condo.longitude
    end
    
    def icons
      icons = []
      icons = Category.icons.collect {|i| map_icon(i[0], i[1])}
    end

    def map_icon(name, url)
      Cartographer::Gicon.new(
        :name => name, 
        :width => 32, :height => 32, 
        :shadow_width => 56, :shadow_height => 32, 
        :image_url => "#{url}.png", :shadow_url => "#{url}s.png", 
        :anchor_x => 16, :anchor_y => 32,
        :info_anchor_x => 16, :info_anchor_y => 0
      )
    end
   
   def search_sql_string(params_unit)	   		     		
	   	condo_id = params_unit[:condo_id]
	   	bedrooms = params_unit[:bedrooms]
	   	bathrooms = params_unit[:bathrooms]
	   	price_lower = params_unit[:price_lower]
	   	price_upper = params_unit[:price_upper]
	   	sort_by = params_unit[:sort_by]
	   	sale_or_rent = params_unit[:sale_or_rent]	   
	   	first_condition = true	   	
	   	sql_string = "SELECT * FROM units, condos, firms WHERE "
	   	
	   	# Full SQL Statement
	   	# SELECT *
			# FROM units, condos, firms
			# WHERE condo_id = 'condo_id' AND units.bedrooms = 'bedrooms' 
			#                             AND units.bathrooms='bathrooms' 
			#                             AND units.price >= 'price_lower' 
			#                             AND units.price <= 'price_upper' 
			#                             AND sale_or_rent = 'sale' ***** TODO *******
			# AND units.condo_id = condos.id AND units.firm_id = firms.id
	   	
	   if condo_id != ""
	   		first_condition = false
	   		sql_string << "condo_id = " << condo_id	   		
	   	end
	   		
	   	if bedrooms != ""	   			
	   			first_condition ? "" : sql_string << " AND "  	
	   			first_condition = false
	   		 	sql_string << "bedrooms = " << bedrooms	   		 	
	   	end
	   	
	   	if bathrooms != ""	   			
	   			first_condition ? "" : sql_string << " AND "  	
	   			first_condition = false
	   		 	sql_string << "bathrooms = " << bathrooms
	   	end
	   	
	   	if price_lower != ""
	   			first_condition ? "" : sql_string << " AND "  	
	   			first_condition = false
	   		 	sql_string << "price >= " << price_lower
	  	end
	  	
	  	if price_upper != ""
	   			first_condition ? "" : sql_string << " AND "  	
	   			first_condition = false
	   		 	sql_string << "price <= " << price_upper
	  	end
	  	
	  	if sale_or_rent != ""
	   			first_condition ? "" : sql_string << " AND "  	
	   			first_condition = false
	   		 	sql_string << "sale_or_rent = " << "'" << sale_or_rent << "'"
	  	end
	  		   	
	   	first_condition ? sql_string << "units.condo_id = condos.id AND units.firm_id = firms.id AND active = '1'" : 
	   	                  sql_string << " AND units.condo_id = condos.id AND units.firm_id = firms.id AND active = '1'"
	   	                  
			if sort_by != ""  				
				# breakpoint
				if session[:sort_desc_or_asc].nil?			
					@sort_order = " DESC"			
					session[:sort_desc_or_asc] = " DESC"		
				else				
					if session[:sort_desc_or_asc].to_s == " DESC"	
						@sort_order = " ASC"
						session[:sort_desc_or_asc] = " ASC"
					else
						@sort_order = " DESC"
						session[:sort_desc_or_asc] = " DESC"
					end						
				end				
				# breakpoint											
	   		 	sql_string << " ORDER BY " << sort_by
	   		 	sql_string << @sort_order
	  	end
	   	
	   	sql_string   	
	   	
   end
	
end