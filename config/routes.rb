Designax::Application.routes.draw do

  match 'image_data/image/:id'  => 'image_data#show_image'
  match 'image_data/thumbnail/:id'  => 'image_data#show_thumbnail'
  match 'design_data/image/:id' => 'design_data#show_image'
  match 'design_data/thumb/:id' => 'design_data#show_thumbnail'
  match 'image_data/get_removeImages/:id' => 'image_data#get_removeImages'
  match 'image_data/get_firstfile/:id' => 'image_data#get_firstfile'
  match 'image_data/get_imagefiles/:id' => 'image_data#get_imagefiles'
  match 'image_data/get_currentId/:id' => 'image_data#get_currentId'

  resources :design_data
  resources :image_data

  devise_for :users, :path_prefix => 'd', :controllers => {
    :registrations => "users/registrations"
  }
  resources :users, only: [:index, :edit, :update, :destroy]
  
  resources :corp_states
  resources :states
  resources :user_infos
  resources :projects
  resources :user_projects

  root :to => 'design_data#index'
end
