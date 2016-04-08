class PhotoGalleryTypesController < ApplicationController
  layout "admin"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @photo_gallery_types_pages, @photo_gallery_types = paginate :photo_gallery_types, :per_page => 10
  end

  def show
    @photo_gallery_types = PhotoGalleryTypes.find(params[:id])
  end

  def new
    @photo_gallery_types = PhotoGalleryTypes.new
  end

  def create
    @photo_gallery_types = PhotoGalleryTypes.new(params[:photo_gallery_types])
    if @photo_gallery_types.save
      flash[:notice] = 'PhotoGalleryTypes was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @photo_gallery_types = PhotoGalleryTypes.find(params[:id])
  end

  def update
    @photo_gallery_types = PhotoGalleryTypes.find(params[:id])
    if @photo_gallery_types.update_attributes(params[:photo_gallery_types])
      flash[:notice] = 'PhotoGalleryTypes was successfully updated.'
      redirect_to :action => 'show', :id => @photo_gallery_types
    else
      render :action => 'edit'
    end
  end

  def destroy
    PhotoGalleryTypes.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
