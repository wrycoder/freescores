Rails.application.routes.draw do
  get 'dashboard/show'
  post 'sessions/create'
  get 'sessions/destroy'
  get 'sessions/new'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :works
  resources :instruments, only: [:new, :create, :show,
                                 :index, :edit, :update]
  resources :genres, only: [:new, :create, :index, :update]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "works#index"
end
