ActionController::Routing::Routes.draw do |map|


  map.resources :user_school_assignments

  map.namespace :district do |district|
    district.resources :schools
    district.resources :users
    district.resources :students
  end

  map.namespace :school do |school|
    school.resources :students
  end

  map.resources :custom_probes

  map.resources :news_items


  map.resources :roles

  map.resources :principal_overrides, :member => {:undo=> :put}


  map.resources :probe_questions


  map.logout '/logout',:controller=>'login',:action=>'logout'

  map.resources :groups, :member=>{:add_student_form => :get,:add_student => :post , :remove_student => :delete}


  map.resources :tiers


  map.resources :checklists
  map.resources :recommendations

  map.resources :student_comments

  map.resources :ignore_flags

  map.resources :custom_flags


  map.resources :enrollments

  map.resources :students, :collection => {:search => :get, :select => :post, :member_search=>:post, :grade_search=>:post}

  map.resources :schools, :collection => {:select => :post}


  map.resources :users

  map.resources :frequencies

  map.resources :districts, :member => {:reset_password => :put, :recreate_admin => :put }

  map.resources :states, :member => {:reset_password => :put, :recreate_admin => :put }

  map.resources :countries, :member => {:reset_password => :put, :recreate_admin => :put }

  map.namespace :checklist_builder do |checklist_builder|
    checklist_builder.resources :checklists,  :member => { :preview => :get, :new_from_this => :post } do |checklist|
      checklist.resources :questions, :member => {:move=> :post},:name_prefix=>"checklist_builder_" do |question|
        question.resources :elements, :member => {:move=> :post},:name_prefix=>"checklist_builder_" do |element|
          element.resources :answers, :member => {:move => :post}, :name_prefix=>"checklist_builder_"
        end
      end
    end
  end

  map.namespace :intervention_builder do |intervention_builder|
    intervention_builder.resources :probes, :member=>{:disable => :put}
    intervention_builder.resources :goals, :member=>{:disable => :put, :move=>:put} do |goal|
      goal.resources :objectives,  :member=>{:disable =>:put, :move =>:put }, :name_prefix=>"intervention_builder_" do |objective|
        objective.resources :categories,:member=>{:disable =>:put, :move =>:put }, :name_prefix=>"intervention_builder_" do |category|
          category.resources :interventions ,:member=>{:disable =>:put, :move =>:put }, :name_prefix=>"intervention_builder_" 
        end
      end
    end
  end
  
  map.namespace :interventions do |intervention|
    intervention.resources :goals, :collection=>{:select=>:post} do |goal|
      goal.resources :objectives, :collection => {:select=> :post},:name_prefix=>"interventions_" do |objective|
        objective.resources :categories, :collection => {:select=> :post},:name_prefix=>"interventions_" do |category|
          category.resources :definitions, :collection => {:select => :post}, :name_prefix=>"interventions_"
        end
      end
    end
  end

  map.resources :interventions, :member=>{:end=>:put} do |intervention|
    intervention.resources :comments, :controller=>"interventions/comments"
    intervention.resources :participants, :controller=>"interventions/participants"
    intervention.resources :probe_assignments, :controller=>"interventions/probe_assignments", :collection=>{:disable_all=>:put} do |probe_assignment|
      probe_assignment.resources :probes, :controller=>"interventions/probes", :name_prefix=>"", 
        :collection=>{:new_assessment=>:get, :update_assessment=>:get,:save_assessment=>:post}
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
