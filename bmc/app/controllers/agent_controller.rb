class AgentController < ApplicationController
	layout "admin"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  	@agents_tab = "currentTab"	
    @agent_pages, @agents = paginate :agents, :per_page => 200
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(params[:agent])
    if @agent.save
      flash[:notice] = 'Agent was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def update
    @agent = Agent.find(params[:id])
    if @agent.update_attributes(params[:agent])
      flash[:notice] = 'Agent was successfully updated.'
      redirect_to :action => 'show', :id => @agent
    else
      render :action => 'edit'
    end
  end

  def destroy
    Agent.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
