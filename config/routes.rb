Rails.application.routes.draw do
  scope '(:locale)' do
    controller :sessions do
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end

    namespace :admin do
      resources :patients do
        get 'sort', on: :collection
      end

      put '/nurse_assignments', to: 'nurse_assignments#update'
      post '/nurse_assignments', to: 'nurse_assignments#create'

      get 'nurses/admin', to: 'nurses#sort'
      resources :nurses do
        resources :patients
      end

      resources :rooms do
        get 'sort', on: :collection
        get 'summary', on: :collection
      end

      resources :doctors do
        get 'sort', on: :collection
      end

      root 'sessions#new'
    end

    put '/nurse_assignments', to: 'nurse_assignments#update'
    post '/nurse_assignments', to: 'nurse_assignments#create'

    resources :patients do
      get 'information', on: :member
      get 'sort', on: :collection
    end

    resources :nurses, except: [:destroy, :create] do
      get 'sort', on: :collection
    end

    resources :nurses do
      resources :patients
    end
    root 'sessions#new'
  end

  mount ActionCable.server, at: '/cable'
end
