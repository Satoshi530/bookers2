Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'
root to: "homes#top"
devise_for :users

resources :books, only:[:new, :create, :index, :show, :edit, :update, :destroy] do
  resources :book_comments, only: [:create, :destroy]
  resource :favorites, only:[:create, :destroy]
end

resources :users, only:[:edit, :show, :update, :index] do
  resource :relationships, only: [:create, :destroy]
  get 'followings' => 'relationships#followings', as: 'followings'
  get 'followers' => 'relationships#followers', as: 'followers'
end

get '/home/about' => 'homes#about', as: "about"
end
