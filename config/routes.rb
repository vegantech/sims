Sims::Application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    passwords: "users/passwords"
  }

  devise_scope :user do
    get '/logout' => 'users/sessions#destroy', :as => :logout
    get '/login' => "users/sessions#new"
    get 'login/login' => "users/sessions#new"
    get 'login/logout' => 'users/sessions#destroy'
    get '/users/sign_out' => 'users/sessions#destroy'
  end

  match '/change_password' => 'main#change_password', :as => :change_password, :via => [:get, :put, :patch]

  resources :personal_groups

  get '/doc/' => 'doc#index', :as => :doc
  get '/system/district_generated_docs/:district_id/:filename(.:format)' => "reports#intervention_definition_summary_report"
  resources :unattached_interventions do
    member do
      put :update_end_date
    end
  end

  resources :grouped_progress_entries do
    member do
      get :aggregate
      put :end
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

  get '/main' => 'main#not_authorized', :as => :not_authorized
  get '/file/:filename' => 'file#download', :as => :download_file, :constraints => { :filename => /[^\/;,?]+/ }
  post '/preview_graph/:intervention_id' => 'interventions/probe_assignments#preview_graph', :as => :preview_graph


  resources :help
  resources :quicklist_items
  match '/stats' => 'stats#index', :as  => :stats, :via => [:get, :post]

  match "/tiers/:id/destroy" => "tiers#destroy", :as => :destroy_tier, :via => [:get, :delete]
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
        put :claim
      end
    end
    resources :logs, :only => [:index]
  end
  scope "district" do
    resources :flag_categories, :as => "flag_categories", :module => "district"
  end

  resources :custom_probes

  resources :news_items

  resources :principal_overrides do
    member do
      put :undo
    end
  end



  resources :groups do
    scope :module => :groups, :only => [:new, :create, :destroy] do
      resources :students
      resources :users
    end
  end
  resources :special_user_groups, :only => [:show, :edit, :create, :destroy]


  resources :checklists
  resources :recommendations

  get '/custom_flags/delete/:id' => 'custom_flags#destroy', :as => :delete_custom_flag
  resources :custom_flags
  resources :ignore_flags

  resources :enrollments



  resources :students, :only => [:index, :create, :show] do
    resources :student_comments, :except => :index
  end


  resources :schools , :only => [:index, :show, :create] do
    resource :student_search, :only => [:show, :create] do
      collection do
        get :member
        get :grade
      end
    end
  end

  resources :districts do
    member do
      put :reset_password
      put :recreate_admin
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
    resources :checklists do
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
    put "regenerate_intervention_pdfs", :controller => :base
    get "interventions_without_recommended_monitors",   :controller => :base

    match "recommended_montors/:action", :controller => :recommended_monitors, :via => [:get, :post, :put, :patch]
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
              post :disable
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
  scope "/interventions/:intervention_id/probe_assignments/:probe_assignment_id", :module => "interventions" do
    resources :probes
  end


  #or just railmail_index controller railmail?
  resources :railmail, :only => %w(index) do
    get  'raw',    :on => :member
    get  'part',   :on => :member
    post 'resend', :on => :collection
    post 'read',   :on => :collection
  end
  root :to =>'main#index'

  match 'reports/:action(.:format)', :controller => "reports", :via => [:get, :post]
  get 'doc/:action(/:id)(.:format)', :controller => "doc"
  match 'scripted/:action(.:format)', :controller => "scripted", :via => [:get, :post]
  match 'intervention_builder/:controller/:action(.:format)', :via => [:get, :post, :put, :delete, :patch] # for controller specs
  post 'spell_check/check_spelling' => "spell_check#check_spelling"
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
#  match 'checklist_builder/:controller/:action(.:format)'# for controller specs
#  match ':controller(/:action(/:id(.:format)))'
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
