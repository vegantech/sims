ActionController::Routing::Routes.draw do |map|
  map.resources :cico_settings, :has_many => :cico_school_days
  map.resources :personal_groups

#TODO FIXME The path prefixes are missing, I might want to remove the deep nesting.


  map.cico '/cico', :controller => 'cico'

  map.doc '/doc/', :controller => 'doc'
  map.resources :unattached_interventions, :member => {:update_end_date => :put }

  map.resources :grouped_progress_entries, :member =>{:aggregate => :get }

  map.resources :flag_descriptions

  map.resources :school_teams

  map.resources :consultation_form_requests

  map.resources :consultation_forms

  map.resources :team_consultations, :member => {:complete => :put, :undo_complete => :put}

  map.stats '/stats', :controller => 'main', :action => 'stats'


  map.spell_check '/spell_check/', :controller => 'spell_check'

  map.change_password '/change_password', :controller=> 'login', :action => 'change_password'
  map.download_file '/file/:filename', :controller=>'file', :action => 'download', :requirements => { :filename => %r([^/;,?]+) }

  map.preview_graph '/preview_graph/:intervention_id', :controller => 'interventions/probe_assignments', :action => 'preview_graph'
  
  map.resources :help
  map.resources :quicklist_items


  map.resources :tiers, :member=>{:move => :put }

  map.resources :user_school_assignments

  map.namespace :district do |district|
    district.resources :schools
    district.resources :users
    district.resources :students, :collection => {:check_id_state => :get}
    district.resources :flag_categories, :name_prefix=>nil
  end

  map.namespace :school do |school|
    school.resources :students
  end

  map.resources :custom_probes

  map.resources :news_items



  map.resources :principal_overrides, :member => {:undo=> :put}





  map.logout '/logout',:controller=>'login',:action=>'logout'

  map.resources :groups, :member=>{:add_student_form => :get,:add_student => :post , :remove_student => :delete,
            :add_user_form => :get, :add_user => :post, :remove_user => :delete, :remove_user => :get,
            :show_special => :get, :remove_special => :delete, :add_special_form => :get, :add_special =>:post }



  map.resources :checklists
  map.resources :recommendations


  map.delete_custom_flag '/custom_flags/delete/:id', :controller=>"custom_flags",:action=>'destroy'

  map.resources :custom_flags


  map.resources :enrollments

  map.resources :students, :collection => {:search => :get, :select => :post, :member_search=>:post, :grade_search=>:post} do |student|
    student.resources :student_comments, :except => :index

  end

  map.resources :schools, :collection => {:select => :post}


  map.resources :users


  map.resources :districts, :member => {:reset_password => :put, :recreate_admin => :put, :logs => :get}, 
    :collection=>{:bulk_import_form => :get, :bulk_import =>:post, :bulk_import => :get, :export => :get}


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
    intervention_builder.resources :goals, :member=>{:disable => :put, :move=>:put},
      :collection=>{:regenerate_intervention_pdfs => :put,  :interventions_without_recommended_monitors => :get} do |goal|
      goal.resources :objectives,  :member=>{:disable =>:put, :move =>:put }, :name_prefix=>"intervention_builder_" do |objective|
        objective.resources :categories,:member=>{:disable =>:put, :move =>:put }, :name_prefix=>"intervention_builder_" do |category|
          category.resources :interventions ,:member=>{:disable =>:put, :move =>:put },:collection=>{:sort => :post}, :name_prefix=>"intervention_builder_" 
        end
      end
    end
  end
  
  map.namespace :interventions do |intervention|
    intervention.resources :quicklists, :only => [:index, :create]
    intervention.resources :goals, :collection=>{:select=>:post} do |goal|
      goal.resources :objectives, :collection => {:select=> :post},:name_prefix=>"interventions_" do |objective|
        objective.resources :categories, :collection => {:select=> :post},:name_prefix=>"interventions_" do |category|
          category.resources :definitions, :collection => {:select => :post}, :name_prefix=>"interventions_"
        end
      end
    end
  end

  map.resources :interventions, :member=>{:undo_end =>:put,:end=>:put}, :collection=>{:ajax_probe_assignment => :get} do |intervention|
    intervention.resources :comments, :controller=>"interventions/comments"
    intervention.resources :participants, :controller=>"interventions/participants"
    intervention.resources :probe_assignments, :controller=>"interventions/probe_assignments", :collection=>{:disable_all=>:put}, :member => {:preview_graph =>:get} do |probe_assignment|
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
