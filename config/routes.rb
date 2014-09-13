Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/logout' => 'devise/sessions#destroy', as: :logout
  end

  get 'sign_in' => 'home#index', as: :new_session

  root 'home#index'
end
