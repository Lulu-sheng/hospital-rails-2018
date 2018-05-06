Rails.application.routes.draw do
  controller :sessions do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destory'
  end

  root 'patients#index', as: 'patient_index'

  get '/doctors/update_mentor_salary', to: 'doctors#update_mentor_salary'
  get '/doctors/sort_doctors', to: 'doctors#sort_doctors'
  get '/patients/add_patient', to: 'patients#add_patient'
  get '/patients/remove_patient', to: 'patients#remove_patient'
  get '/patients/change_ownership', to: 'patients#change_ownership'
  get '/nurses/sort', to: 'nurses#sort'
  get '/patients/sort', to: 'patients#sort'
  get '/nurse/:nurse_id/patients/sort', to: 'patients#sort'
  get '/patients_under_nurse/:nurse_id', to: 'patients#subset_under_nurse'
  put '/nurse_assignments', to: 'nurse_assignments#update'

  resources :patients do
    get 'information', on: :member
  end

  resources :doctors do 
    resources :patients
  end
  resources :nurses do
    resources :patients
  end
  resources :nurse_assignments

  mount ActionCable.server, at: '/cable'
end
