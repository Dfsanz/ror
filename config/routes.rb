ActionController::Routing::Routes.draw do |map|
		
  map.resources :leads
  map.resources :users
  map.resources :businesses, :collection => {:list => :get}
  map.resources :categories
  
  map.show_guide "community/brickell-and-downtown-miami", :controller => "businesses", :action => "index"
  map.show_category "community/brickell-and-downtown-miami/category/:category_id", :controller => "businesses", :action => "index"
  map.show_business "community/brickell-and-downtown-miami/:id", :controller => "businesses", :action => "show"
  map.show_rentals "condos/downtown-miami-and-brickell-rentals", :controller => "real_estate", :action => "rentals"
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

 # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => 'real_estate',
  								:action => 'home'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  map.resources :users, :member => { :enable => :put } do |users|
    users.resources :roles
  end
  
  map.home '',
  	:controller => 'real_estate',
  	:action => 'home'
  	
	map.real_estate 'condos',
  	:controller => 'real_estate',
  	:action => 'index' 

  map.condo 'condos/:permalink_condo',
  	:controller => 'real_estate',
  	:action => 'show'
 
  map.unit 'condos/:permalink_condo/:permalink_unit',
  	:controller => 'real_estate',
  	:action => 'unit'   	
  
  map.show_user '/user/:username', 
                 :controller => 'users', 
                 :action => 'show_by_username'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'   
end
