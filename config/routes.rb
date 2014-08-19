Mobonotes::Application.routes.draw do
  root :to => "dates#show"

  get "dates/:start_date" => "dates#show", :as => :date
  get "dates/:start_date/:end_date" => "dates#show", :as => :date_range

  resources :labels, :only => [:show, :index] do
    get "dates/:start_date", :on => :member, :to => :show, :as => :date
    get "dates/:start_date/:end_date", :on => :member, :to => :show, :as => :date_range

    resources :tasks, :module => "labels", :only => :index do
      get "dates/:start_date", :on => :collection, :to => :index, :as => :date
      get "dates/:start_date/:end_date", :on => :collection, :to => :index, :as => :date_range
    end

    resources :notes, :module => "labels", :only => :index do
      get "dates/:start_date", :on => :collection, :to => :index, :as => :date
      get "dates/:start_date/:end_date", :on => :collection, :to => :index, :as => :date_range
    end
  end

  resources :tasks do
    get "dates/:start_date", :on => :collection, :to => :index, :as => :date
    get "dates/:start_date/:end_date", :on => :collection, :to => :index, :as => :date_range

    put "complete", :on => :member
    put "uncomplete", :on => :member

    resources :notes, :controller => "tasks/notes", :only => [:create, :update, :destroy]
  end

  resources :notes, :only => "index" do
    get "dates/:start_date", :on => :collection, :to => :index, :as => :date
    get "dates/:start_date/:end_date", :on => :collection, :to => :index, :as => :date_range
  end

  get "login" => "sessions#new", :via => :get, :as => :login
  get "logout" => "sessions#destroy", :as => :logout
  post "sessions/create" => "sessions#create", :via => :post, :as => :create_session

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
end
