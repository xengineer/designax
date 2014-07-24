Designax::Application.routes.draw do

  resources :user_groups
  resources :groups

  match 'image_data/image/:id'  => 'image_data#show_image'
  match 'image_data/thumbnail/:id'  => 'image_data#show_thumbnail'
  match 'design_data/image/:id' => 'design_data#show_image'
  match 'design_data/thumb/:id' => 'design_data#show_thumbnail'
  match 'image_data/get_removeImages/:id' => 'image_data#get_removeImages'
  #match 'image_data/get_updateDlg/:id' => 'image_data#get_updateDlg'
  match 'image_data/get_firstfile/:id' => 'image_data#get_firstfile'
  match 'image_data/get_imagefiles/:id' => 'image_data#get_imagefiles'
  match 'image_data/get_currentId/:id' => 'image_data#get_currentId'
  resources :design_data


  resources :image_data

  devise_for :users, :controllers => {
    :registrations => "users/registrations"
  }

  resources :corp_states


  resources :states


  resources :user_infos


  resources :projects


  resources :user_projects


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
  # root :to => 'welcome#index'
  root :to => 'design_data#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
