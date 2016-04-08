class UnitController < ApplicationController
	layout "admin"
	
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }	

  def index
    list
    render :action => 'list'
  end
  
  def list_units_for_condo
  	load_data
  	@unit_pages, @units = paginate :units, 
  												:conditions => ["units.condo_id=?", params[:condo_id]],
  												:per_page => 200  	
	end	
  
  def list
  	load_data
    @unit_pages, @units = paginate :units, :per_page => 200
  end

  def show
  	load_data
    @unit = Unit.find(params[:id])
  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(params[:unit])
    if @unit.save
      flash[:notice] = 'Unit was successfully created.'
      redirect_to :action => 'list'
    else
    	load_data
      render :action => 'new'
    end
  end

  def edit
  	load_data
    @unit = Unit.find(params[:id])
    photo_galleries
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update_attributes(params[:unit])
      flash[:notice] = 'Unit was successfully updated.'
      redirect_to :action => 'show', :id => @unit
      # expire_page(:controller => 'real-estate', :action => 'show', :id => record.photo_gallery.unit_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Unit.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
    def photo_galleries  	
  	@photo_galleries, @photo_galleries = paginate :photo_galleries, 
  												:conditions => ["photo_galleries.unit_id=?", params[:id]],
  												:per_page => 200      	
	end
  
  private
  def load_data
      @condos = Condo.find(:all)
      @firms = Firm.find(:all)
      @agents = Agent.find(:all)
      @photo_gallery_types = PhotoGalleryType.find(:all) 
   end
   

   
   
    
end
