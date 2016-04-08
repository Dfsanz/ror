class PhotoGalleryTypeController < ApplicationController
  layout "admin"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @photo_gallery_type_pages, @photo_gallery_types = paginate :photo_gallery_types, :per_page => 10
  end

  def show
    @photo_gallery_type = PhotoGalleryType.find(params[:id])
  end

  def new
    @photo_gallery_type = PhotoGalleryType.new
  end

  def create
    @photo_gallery_type = PhotoGalleryType.new(params[:photo_gallery_type])
    if @photo_gallery_type.save
      flash[:notice] = 'PhotoGalleryType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @photo_gallery_type = PhotoGalleryType.find(params[:id])
  end

  def update
    @photo_gallery_type = PhotoGalleryType.find(params[:id])
    if @photo_gallery_type.update_attributes(params[:photo_gallery_type])
      flash[:notice] = 'PhotoGalleryType was successfully updated.'
      redirect_to :action => 'show', :id => @photo_gallery_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    PhotoGalleryType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
