Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "question#index"

  resources :question
  resources :user
  resources :tag
  resources :comment, only: [:create, :update]
  resources :answer, only: [:create, :edit, :update, :destroy]
  resources :vote, only: [:create]
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'static_pages/page_not_found'
  get '/search', to:'static_pages#search'
  post 'question/restore/:id', to:'question#restore'
end
