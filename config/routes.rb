Rails.application.routes.draw do
  root 'landing#index'

  get 'student/index'
  get 'student/schedule'

  post 'student/schedule' => 'student#schedule_session'
end
