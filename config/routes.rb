RichmondTreesAdmin::Application.routes.draw do
  resources :zones

  post 'map', :controller => 'map', :action => 'index'

  resources :notes, except: :edit

  resources :maintenance_records

  resources :adoption_requests

  resources :plantings

  resources :trees

  # login page
  root :controller => "user_sessions", :action => "new"

  resources :users

  resources :user_sessions
  get 'login', :controller => 'user_sessions', :action => 'new'
  get 'logout', :controller => 'user_sessions', :action => 'destroy'

  # home page when logged in
  get 'home', :controller => 'homepage', :action => 'index'

  # reports
  get 'reports/plantings', :controller => 'reports'
  get 'reports/plantings_results', :controller => 'reports'
  get 'reports/adoption_requests', :controller => 'reports'
  get 'reports/adoption_requests_results', :controller => 'reports'

  # password resets
  resources :password_resets, :only => [ :new, :create, :edit, :update ]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
