class BusinessesController < ApplicationController
  before_filter :setup_map, :only => [ :index, :show ]
  before_filter :setup_small_map, :only => [:show]
  before_filter :set_categories, :only => [ :index, :show, :new, :edit ]
  
  # GET /businesses
  # GET /businesses.xml
  def index
    @page_title = "Downtown Miami Guide"
  	@community_guide_tab  = "currentTab"	
    @map.width = 606
    @map.height = 1220
    if params[:category_id]
      if params[:category_id] == "condos" 
	  	@page_title = "Brickell Condos and Downtown Miami Condos" 
      	@currentTab = "currentTab"    
        @businesses = Condo.find(:all, :order => "condos.name asc")
      else
        @category = Category.find(params[:category_id])        
        @businesses = @category.businesses
		if params[:category_id] == "15-hotels"
			@page_title = "Brickell Hotels and Downtown Miami Hotels"
		elsif params[:category_id] == "13-restaurants"
			@page_title = "Brickell Restaurants and Downtown Miami Restaurants"
		elsif params[:category_id] == "14-bars"
			@page_title = "Brickell Bars and Downtown Miami Bars"	
		end
		
      end
    elsif params[:query]
      @businesses = Business.find_with_index(params[:query])	 
    else
      # @businesses = Business.find(:all) 
      @currentTab = "currentTab"      
      @businesses = Condo.find(:all, :order => "condos.name asc")
    end
    
    @businesses.each { |b| add_business_to_map(b, @map) }
    @icons = icons
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @businesses }
    end
  end
  
  def list
    @businesses = Business.find(:all)
  end
  
  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @map.width = 520
    @map2.width = 200
    @icons = icons
    @business = Business.find(params[:id])
    add_business_to_map(@business, @map)
    add_business_to_map(@business, @map2)
	@page_title = @business.name + " - Brickell and Downtown Miami Guide"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.xml
  def new
    @business = Business.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/1/edit
  def edit
    @business = Business.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @business = Business.new(params[:business])
    @business_photo = @business.build_business_photo(params[:business_photo]) unless params[:business_photo][:uploaded_data].blank?
    respond_to do |format|
      if @business.save
        flash[:notice] = 'Business was successfully created.'
        format.html { redirect_to list_businesses_url }
        format.xml  { render :xml => @business, :status => :created, :location => @business }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    @business = Business.find(params[:id])
    @business.category_ids = [] unless params[:category_ids]
    @business_photo = @business.build_business_photo(params[:business_photo]) unless params[:business_photo][:uploaded_data].blank?
    respond_to do |format|
      if @business.update_attributes(params[:business])
        flash[:notice] = 'Business was successfully updated.'
        format.html { redirect_to list_businesses_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.xml
  def destroy
    @business = Business.find(params[:id])
    @business.destroy

    respond_to do |format|
      format.html { redirect_to(list_businesses_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
    def set_categories
      @categories = Category.find_parents(:all)
    end
    
    def add_business_to_map(business, map)
      info_window = render_to_string :partial => 'info_window', :locals => { :business => business }
      info_window.gsub!(/"/, '\\"')
      
      marker_name = "marker_#{business.class.to_s.downcase}_#{business.id}"
      map.markers << Cartographer::Gmarker.new({
            :position => [business.latitude.to_f, business.longitude.to_f], 
            :info_window => info_window,
            :map => map,
            :name => marker_name,
            :icon => business.icon,
            :click => "#{@map.dom_id}.panTo(new GLatLng(#{business.latitude.to_f}, #{business.longitude.to_f})); #{map.ewindow_control}.openOnMarker(#{marker_name}, \"#{info_window}\")"
      }) if business.latitude && business.longitude
    end
    
    def setup_map
      @map = Cartographer::Gmap.new(:name => 'mymap')
      # @map.autocenter = true
      @map.center = [25.768100, -80.19186]
      @map.controls << :zoom
      @map.controls << :large
       @map.controls << :type       
      @map.zoom = 15
      @map.ewindow_control = 'ew'
    end
    
    def setup_small_map
      @map2 = Cartographer::Gmap.new(:name => 'mymap')
      @map2.autocenter = true
      @map2.controls << :zoom
      @map2.controls << :small
      @map2.zoom = 17
      @map2.ewindow_control = 'ew'
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
end
