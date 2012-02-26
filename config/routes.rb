Rails.application.routes.draw do
  resources :personal_groups

  match '/doc/' => 'doc#index', :as => :doc
  match '/system/district_generated_docs/:district_id/:filename(.:format)' => "reports#intervention_definition_summary_report"
  resources :unattached_interventions do
    member do
      put :update_end_date
    end
  end

  resources :grouped_progress_entries do
    member do
      get :aggregate
    end
  end
  resources :flag_descriptions
  resources :school_teams
  resources :consultation_form_requests
  resources :consultation_forms
  resources :team_consultations do
    member do
      put :complete
      put :undo_complete
    end
  end

  match '/stats' => 'main#stats', :as => :stats
  match '/spell_check/' => 'spell_check#index', :as => :spell_check
  match '/change_password' => 'login#change_password', :as => :change_password
  match '/file/:filename' => 'file#download', :as => :download_file, :constraints => { :filename => /[^\/;,?]+/ }
  match '/preview_graph/:intervention_id' => 'interventions/probe_assignments#preview_graph', :as => :preview_graph


  resources :help
  resources :quicklist_items

  match "/tiers/:id/destroy" => "tiers#destroy", :as => :destroy_tier
  resources :tiers do
    member do
      put :move
    end
  end

  resources :user_school_assignments

  namespace :district do
    resources :schools
    resources :users
    resources :students do
      collection do
        get :check_id_state
      end
      member do
        get :claim
      end
    end
  end
  scope "district" do
    resources :flag_categories, :as => "flag_categories", :module => "district"
  end

  namespace :school do
    resources :students
  end

  resources :custom_probes

  resources :news_items

  resources :principal_overrides do
    member do
      put :undo
    end
  end


  match '/logout' => 'login#logout', :as => :logout

  resources :groups do
    member do
      get :add_student_form
      post :add_student
      delete :remove_student
      get :add_user_form
      post :add_user
      delete :remove_user
      get :remove_user
      get :show_special
      delete :remove_special
      get :add_special_form
      post :add_special
    end
  end


  resources :checklists
  resources :recommendations


  match '/custom_flags/delete/:id' => 'custom_flags#destroy', :as => :delete_custom_flag
  resources :custom_flags

  resources :enrollments

  resources :students do
    collection do
      get :search
      post :select
      post :member_search
      post :grade_search
    end
    resources :student_comments, :except => :index
  end


  resources :schools do
    collection do
      post :select
    end
  end


  resources :users


  resources :districts do
    member do
      put :reset_password
      put :recreate_admin
      get :logs
    end
    collection do
      get :bulk_import_form
      post :bulk_import
      get :bulk_import
      get :export
    end
  end

  #name prefix was _checklist_builder before
  namespace :checklist_builder do
    resources :checklists,  :member => { :preview => :get, :new_from_this => :post } do
      member do
        get :preview
        post :new_from_this
      end
    end
    scope "/checklists/:checklist_id" do
      resources :questions do
        member do
          post :move
        end
      end
      scope "questions/:question_id" do
        resources :elements do
          member do
            post :move
          end
        end
        scope "elements/:element_id" do
          resources :answers do
            member do
              post :move
            end
          end
        end
      end
    end
  end


  namespace :intervention_builder do
    resources :probes do
      member do
        put :disable
      end
      collection do
        post :disable
      end
    end
    resources :goals do
      member do
        put :move
        put :disable
      end
      collection do
        put :regenerate_intervention_pdfs
        get :interventions_without_recommended_monitors
      end
    end
    scope "/goals/:goal_id" do
      resources :objectives do
        member do
          put :disable
          put :move
        end
      end
      scope "/objectives/:objective_id" do
        resources :categories do
          member do
            put :disable
            put :move
          end
        end
        scope "/categories/:category_id" do
          resources :interventions do
            member do
              put :disable
              put :move
            end
            collection do
              put :disable
              post :sort
            end
          end
        end
      end
    end
  end

  namespace :interventions, :only => [:index, :create] do
    resources :quicklists
    resources :goals
    scope "/goals/:goal_id" do
      resources :objectives
      scope "/objectives/:objective_id" do
        resources :categories
        scope "/categories/:category_id" do
          resources :definitions
        end
      end
    end
  end




  resources :interventions do
    member do
      put :undo_end
      put :end
    end
    collection do
      get :ajax_probe_assignment
    end
    scope :module => "interventions" do
      resources :comments
      resources :participants
      resources :probe_assignments do
        collection do
          put :disable_all
        end
        member do
          get :preview_graph
        end
      end
    end
  end
  scope "/interventions/:intervention_id/probe_assignments/:probe_assignment_id" do
    resources :probes do
      collection do
        get :new_assessment
        get :update_assessment
        post :save_assessment
      end
    end
  end


  #or just railmail_index controller railmail?
  resources :railmail, :only => %w(index) do
    get  'raw',    :on => :member
    get  'part',   :on => :member
    post 'resend', :on => :collection
    post 'read',   :on => :collection
  end
  root :to =>'main#index'

  match ':controller(/:action(/:id(.:format)))'
end

# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
# root :to => "welcome#index"

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'
