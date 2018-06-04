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

      resources :nurses, except: :show do
        get 'sort', on: :collection
        resources :patients
      end

      resources :rooms, except: :show do
        get 'sort', on: :collection
        get 'summary', on: :collection
      end

      resources :doctors do
        get 'sort', on: :collection
      end

      #root 'sessions#new' (no root for admin!)
    end

    put '/nurse_assignments', to: 'nurse_assignments#update'
    post '/nurse_assignments', to: 'nurse_assignments#create'

    resources :patients do
      get 'information', on: :member
      get 'sort', on: :collection
    end

    resources :nurses, except: [:show, :destroy, :create] do
      get 'sort', on: :collection
      resources :patients
    end

    root 'sessions#new'
  end

  mount ActionCable.server, at: '/cable'
end
