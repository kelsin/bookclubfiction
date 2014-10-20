Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  get 'sign_in', to: 'home#index', as: :new_session

  resource :status, defaults: { :format => :json }

  authenticate :user do
    get '/search/:q', to: 'search#search', as: :search, defaults: { :format => :json }

    resources :users, defaults: { :format => :json } do
      post 'vote', :on => :member
      delete 'vote', :on => :member, :action => :unvote
    end

    resources :rounds, defaults: { :format => :json } do
      post 'progress', :on => :member
      post 'backup', :on => :member

      resources :votes, defaults: { :format => :json }

      resources :selections, defaults: { :format => :json }

      resources :nominations, defaults: { :format => :json } do
        post 'vote', :on => :member
        delete 'vote', :on => :member, :action => :unvote
        post 'extra', :on => :member
        delete 'extra', :on => :member, :action => :unextra
      end
    end
  end

  get '*path', to:'home#index'

  root 'home#index'
end
