Tit::Application.routes.draw do

  root :to => 'pictures#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  get 'pictures' => 'pictures#index', as: :pictures
  get 'categories/:title/:id' => 'pictures#show', as: :picture

  get 'categories'=> 'categories#index', as: :categories
  get 'categories/:title' => 'categories#show', as: :category

end