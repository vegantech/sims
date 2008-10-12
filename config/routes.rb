ActionController::Routing::Routes.draw do |map|
  map.resources :student_comments

  map.resources :ignore_flags

  map.resources :custom_flags


  map.resources :enrollments

  map.resources :students, :collection => {:search => :get, :select => :post}

  map.resources :schools, :collection => {:select => :post}


  map.resources :users

  map.resources :frequencies

  map.resources :districts

  map.resources :states

  map.resources :countries

  map.namespace :checklist_builder do |checklist_builder|
    checklist_builder.resources :checklists,  :member => { :preview => :get, :new_from_this => :post } do |checklist|
      checklist.resources :questions, :member => {:move=> :post},:name_prefix=>"checklist_builder_" do |question|
        question.resources :elements, :member => {:move=> :post},:name_prefix=>"checklist_builder_" do |element|
          element.resources :answers, :name_prefix=>"checklist_builder_"
        end
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => "main"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
