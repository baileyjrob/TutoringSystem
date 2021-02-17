Rails.application.routes.draw do
  root 'student#index'
  get 'student/index'
  get 'student/schedule'

  post 'student/schedule' => 'student#schedule_session'
  post 'student/create'
  post 'student/delete'
  post 'student/temp'
  resources :tutoring_session
end
