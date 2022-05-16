Rails.application.routes.draw do
root to: "homes#top"
devise_for :users

resources :books, only:[:new, :create, :index, :show, :edit, :update, :destroy]
resources :users, only:[:edit, :show, :update, :index]
get '/home/about' => 'homes#about', as: "about"
end
