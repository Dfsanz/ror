class CondosController < ApplicationController
	layout "admin"
	
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
     @condo_pages, @condos = paginate :condos, :per_page => 200    
     
    @condo_pages, @condos = paginate :condos, 
    													:per_page => 200,
    													:order => "condos.name asc"
    
   
  end

  def show
    @condo = Condo.find(params[:id])
  end

  def new
    @condo = Condo.new
  end

  def create
    @condo = Condo.new(params[:condo])
    if @condo.save
      flash[:notice] = 'Condo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @condo = Condo.find(params[:id])
  end

  def update
    @condo = Condo.find(params[:id])
    if @condo.update_attributes(params[:condo])
      flash[:notice] = 'Condo was successfully updated.'
      redirect_to :action => 'show', :id => @condo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Condo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
