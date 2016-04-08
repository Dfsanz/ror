class FirmController < ApplicationController
	layout "admin"
		
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  	@firms_tab = "currentTab"	
    @firm_pages, @firms = paginate :firms, :per_page => 200
  end

  def show
    @firm = Firm.find(params[:id])
  end

  def new
    @firm = Firm.new
  end

  def create
    @firm = Firm.new(params[:firm])
    if @firm.save
      flash[:notice] = 'Firm was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @firm = Firm.find(params[:id])
  end

  def update
    @firm = Firm.find(params[:id])
    if @firm.update_attributes(params[:firm])
      flash[:notice] = 'Firm was successfully updated.'
      redirect_to :action => 'show', :id => @firm
    else
      render :action => 'edit'
    end
  end

  def destroy
    Firm.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end