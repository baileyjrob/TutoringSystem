# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'users#index'
  get '/users/index', :to => 'users#index'
  post '/users', :to => 'users#index'
  get '/users/schedule', :to => 'users#show_schedule', :as => :show_schedule
  get '/users/:id', :to => 'users#show', :as => :user
  post '/users/:id/delete_session', :to => 'users#delete_session', :as => :delete_session
  get 'tutor/request_submission'
  get 'tutor/index', :to => 'tutor#index'
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'
  post '/spartan_sessions/check_in_first' => 'spartan_sessions#check_in_first'
  post '/spartan_sessions/check_in_second' => 'spartan_sessions#check_in_second'
  get '/spartan_sessions/index', :to => 'spartan_sessions#index'
  get '/spartan_sessions/:id', :to => 'spartan_sessions#show', :as => :spartan_session
  post '/spartan_sessions/:id/edit_user', :to => 'spartan_sessions#edit_user'
  get '/spartan_sessions/:id/edit_user', :to => 'spartan_sessions#edit_user'
  post '/spartan_sessions/:id/update_attendance', :to => 'spartan_sessions#update_attendance'
  post '/spartan_sessions/:id/add_user', :to => 'spartan_sessions#add_user'
  get '/notifications/:id', :to => 'notification#show'
  get '/tutoring_session/pending', :to => 'tutoring_session_user#show'
  post '/tutoring_session_user/:id/deny', :to => 'tutoring_session_user#deny_pending_link'
  post '/tutoring_session_user/:id/confirm', :to => 'tutoring_session_user#confirm_pending_link'
  # TEMP UNTIL EMAIL
  get '/users/admin_view_hours', :to => 'users#admin_view_hours'
  post '/users/admin_view_hours', :to =>'users#admin_view_hours'
  #END TEMP
  resources :tutoring_session

  resources :users
  resources :tutors

end
