Rails.application.routes.draw do
  root 'home#index'

  get '/welcome', to: 'welcome#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy'
  delete '/me', to: 'users#destroy'
  resources :expressions
  resource :quiz, only: [:show]
  namespace :api do
    resources :expressions, only: [:index, :edit]
    resource :quiz, only: [:show]
    post '/bookmarked_expressions', to: 'bookmarkings#create'
  end
end
