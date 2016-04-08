class PhotoGalleryController < ApplicationController
  layout "admin"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

   def photos
  	@photo_pages, @photos = paginate :photos, 
  												:conditions => ["photos.photo_gallery_id=?", params[:id]],
  												:per_page => 200  	
  	# @unit_id = @photos[0].photo_gallery.unit_id
  	
  	@unit_id = PhotoGallery.find(params[:id]).unit_id
	end
  
  def list
  	@photo_galleries_tab = "currentTab"	
    @photo_gallery_pages, @photo_galleries = paginate :photo_galleries, :per_page => 10
  end

  def show
    @photo_gallery = PhotoGallery.find(params[:id])
  end

  def new
  	load_data
    @photo_gallery = PhotoGallery.new
  end

  def create    
    @photo_gallery = PhotoGallery.new(params[:photo_gallery])
    if @photo_gallery.save
      flash[:notice] = 'PhotoGallery was successfully created.'
      redirect_to :controller => 'unit', :action => 'photo_galleries', :id => params[:photo_gallery][:unit_id]      
    else
      render :action => 'new'
    end
  end

  def edit  	
    @photo_gallery = PhotoGallery.find(params[:id])
  end

  def update
    @photo_gallery = PhotoGallery.find(params[:id])
    if @photo_gallery.update_attributes(params[:photo_gallery])
      flash[:notice] = 'PhotoGallery was successfully updated.'
      redirect_to :action => 'show', :id => @photo_gallery
    else
      render :action => 'edit'
    end
  end

  def destroy
    PhotoGallery.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  private
  def load_data
      @photo_gallery_types = PhotoGalleryType.find(:all)      
   end
end
