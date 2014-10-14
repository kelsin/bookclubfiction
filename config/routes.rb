Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  get 'sign_in', to: 'home#index', as: :new_session

  resource :status, defaults: { :format => :json }

  authenticate :user do
    get '/search/:q', to: 'search#search', as: :search, defaults: { :format => :json }
    resources :rounds, defaults: { :format => :json } do
      resources :nominations, defaults: { :format => :json } do
        resources :votes, defaults: { :format => :json }
      end
    end
  end

  root 'home#index'
end
