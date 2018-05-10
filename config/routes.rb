Rails.application.routes.draw do
  scope '(:locale)' do
    controller :sessions do
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end

    # The following is me testing out a whole different admin
    # section of this webpage.
=begin
  namespace :admin do
    resources :patients
    get '/sort', to: 'patients#sort'
    #get '/patients', to: 'patients#index'
    resources :nurses do
      resources :patients
    end
    get '/sort', to: 'nurses#sort'
    controller :sessions do
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
    end
  end
=end


    # These following routes were left over from the DB1 project! (please ignore)
    #get '/doctors/update_mentor_salary', to: 'doctors#update_mentor_salary'
    #get '/doctors/sort_doctors', to: 'doctors#sort_doctors'
    #get '/patients/add_patient', to: 'patients#add_patient'
    #get '/patients/remove_patient', to: 'patients#remove_patient'
    #get '/patients/change_ownership', to: 'patients#change_ownership'

    get '/nurses/sort', to: 'nurses#sort'
    get '/patients/sort', to: 'patients#sort'
    get '/nurse/:nurse_id/patients/sort', to: 'patients#sort'

    # use resources except!
    put '/nurse_assignments', to: 'nurse_assignments#update'
    post '/nurse_assignments', to: 'nurse_assignments#create'

    resources :patients do
      get 'information', on: :member
    end

    #resources :doctors do 
      #resources :patients
    #end

    resources :nurses do
      resources :patients
    end
    #resources :nurse_assignments
    root 'sessions#new'
  end

  mount ActionCable.server, at: '/cable'
end
