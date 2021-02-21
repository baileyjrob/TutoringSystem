Rails.application.routes.draw do
  root 'student#index'
  #get 'student/index'
  get 'student/schedule'

  post 'student/schedule' => 'student#schedule_session'
  #post 'student/create'
  #post 'student/delete'
  post 'student/temp'
  #resources :student, only: [:index, :create, :destroy]
  resources :student
  resources :tutoring_session
end
