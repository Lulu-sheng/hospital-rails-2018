Rails.application.routes.draw do
  root 'patients#index', as: 'patient_index'

  get '/doctors/update_mentor_salary', to: 'doctors#update_mentor_salary'
  get '/doctors/sort_doctors', to: 'doctors#sort_doctors'
  get '/patients/add_patient', to: 'patients#add_patient'
  get '/patients/remove_patient', to: 'patients#remove_patient'
  get '/patients/change_ownership', to: 'patients#change_ownership'
  get '/nurses/sort', to: 'nurses#sort'
  get '/patients/sort', to: 'patients#sort'

  resources :doctors, only: [:index]
  resources :nurses
  resources :patients

end
