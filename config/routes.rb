Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  get 'sign_in', to: 'home#index', as: :new_session

  get '/search/:q', to: 'search#search', as: :search, defaults: { :format => :json }

  resource :profile, defaults: { :format => :json }
  resource :status, defaults: { :format => :json }

  root 'home#index'
end
