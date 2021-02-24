Rails.application.routes.draw do
  root 'student#index'

  get 'student/schedule'
  post 'student/schedule' => 'student#schedule_session'
  post 'student/temp'
  resources :student
  
  resources :tutoring_session
end
