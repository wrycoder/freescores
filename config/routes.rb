Rails.application.routes.draw do
  get 'dashboard/show'
  get 'dashboard', to: 'dashboard#show'
  post 'sessions/create'
  get 'sessions/destroy'
  get 'sessions/new'
  get 'works/search', to: 'works#search'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :instruments, only: [:new, :create, :show,
                                 :index, :edit, :update]
  resources :genres, only: [:new, :create, :index, :update]
  resources :liner_notes, only: [:new, :create, :edit, :update, :show]
  resources :recordings, only: [:new, :create, :destroy]
  resources :scores, only: [:new, :create, :destroy]
  resources :works do
    resources :recordings
    resources :scores
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "works#index"
end
