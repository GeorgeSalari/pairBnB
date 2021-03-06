Rails.application.routes.draw do
  get 'braintree/new'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, only: [:create, :show, :edit, :update] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
    resources :listings
    resources :reservations, except: [:update]
  end



  root "listings#all"
  get "/listings" => "listings#all", as: "all_listings"
  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
  patch "/listing/:id/add_images" => "listings#add_images", as: "add_images"
  patch "/listing/:id/remove_images" => "listings#remove_image_at_index", as: "remove_images"
  post 'braintree/checkout'
end
