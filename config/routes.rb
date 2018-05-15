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

      #get '/nurse/:nurse_id/patients/sort', to: 'patients#sort'

      resources :rooms do
        get 'sort', on: :collection
      end

      resources :doctors do
        get 'sort', on: :collection
      end

      controller :sessions do
        get 'login', to: 'sessions#new'
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end

      root 'sessions#new'
    end


    # These following routes were left over from the DB1 project! (please ignore)
    #get '/doctors/update_mentor_salary', to: 'doctors#update_mentor_salary'
    #get '/doctors/sort_doctors', to: 'doctors#sort_doctors'
    #get '/patients/add_patient', to: 'patients#add_patient'
    #get '/patients/remove_patient', to: 'patients#remove_patient'
    #get '/patients/change_ownership', to: 'patients#change_ownership'

    #get '/nurse/:nurse_id/patients/sort', to: 'patients#sort'

    # use resources except!
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
