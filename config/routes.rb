Rails.application.routes.draw do
  get 'tutor/index'
  devise_for :users
  root 'student#index'
  get 'student/index'
  get 'student/schedule'
  get 'tutor/matching'
  post 'student/schedule' => 'student#schedule_session'
  post 'student/create'
  post 'student/delete'
  post 'student/temp'
  get '/users/:id', :to => 'users#show', :as => :user
  post 'tutor/index'
  #resources :student, only: [:index, :create, :destroy]
  #resources :student
  resources :tutoring_session
  resources :user
end
