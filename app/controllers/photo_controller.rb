class PhotoController < ApplicationController
  layout "admin"
  
    # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  
  def index
    list
    render :action => 'list'
  end
  
  def list
  	@photos_tab = "currentTab"	
    @photo_pages, @photos = paginate :photos, :per_page => 100
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:photo])
    if @photo.save
      flash[:notice] = 'Photo was successfully created.'
      # redirect_to :action => 'list'
      redirect_to :controller => 'photo_gallery', :action => 'photos', :id => params[:photo][:photo_gallery_id]   
    else
      render :action => 'new'
    end
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to :action => 'show', :id => @photo
    else
      render :action => 'edit'
    end
  end

  def destroy  	
    photo = Photo.find(params[:id])
    photo.destroy    
    redirect_to :controller => 'unit', :action => 'edit', :id => photo.photo_gallery.unit_id
  end
end
