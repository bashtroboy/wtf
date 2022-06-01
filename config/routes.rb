Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/history' => 'history#index'
  get '/about' => 'pages#about'
  root 'queries#index'
  resources :queries
end
