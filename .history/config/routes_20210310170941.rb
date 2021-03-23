Rails.application.routes.draw do
  devise_for :users
  root 'student#index'
  get 'student/index'
  get 'student/schedule'
  post 'student/schedule' => 'student#schedule_session'
  post 'student/create'
  post 'student/delete'
  post 'student/temp'
  get '/users/:id', :to => 'users#show', :as => :user
  get '/users/schedule', :to => 'users#show_schedule', :as => :user
  #resources :student, only: [:index, :create, :destroy]
  #resources :student
  resources :tutoring_session
  resources :user
end
