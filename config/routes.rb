Rails.application.routes.draw do
  root 'home#index'

  get '/welcome', to: 'welcome#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/privacy_policy', to: 'welcome#privacy_policy'
  delete '/logout', to: 'sessions#destroy'
  delete '/me', to: 'users#destroy'
  resources :expressions
  resources :bookmarked_expressions, only: [:index]
  resources :memorised_expressions, only: [:index]
  resource :quiz, only: [:show]
  namespace :bookmarked_expressions do
    resource :quiz, only: [:show]
  end
  namespace :memorised_expressions do
    resource :quiz, only: [:show]
  end
  namespace :api do
    resources :expressions, only: [:index, :edit]
    resource :quiz, only: [:show]
    get '/bookmarked_expressions', to: 'bookmarkings#index'
    get '/memorised_expressions', to: 'memorisings#index'
    post '/bookmarked_expressions', to: 'bookmarkings#create'
    post '/memorised_expressions', to: 'memorisings#create'
    namespace :bookmarked_expressions do
      resource :quiz, only: [:show]
    end
    namespace :memorised_expressions do
      resource :quiz, only: [:show]
    end
  end
end
