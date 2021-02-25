Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  get '/users/destroy_confirm' => 'users#destroy_confirm', as: 'user_destroy_confirm'
  resources :users,only: [:show,:index,:edit,:update] do
    member do
      get :following, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  root 'homes#top'
  get 'home/about' => 'homes#about'
  get '/search' => 'search#search'
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]

  resources :notifications, only: [:index]

  # 開発環境で送信したメールを /letter_opener で確認する
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end