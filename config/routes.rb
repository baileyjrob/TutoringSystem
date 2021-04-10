# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }
  root 'users#index'
  get '/users/index', :to => 'users#index'
  post '/users', :to => 'users#index'
  get '/users/schedule', :to => 'users#show_schedule', :as => :show_schedule
  get '/users/:id', :to => 'users#show', :as => :user
  post '/users/:id/delete_session', :to => 'users#delete_session', :as => :delete_session
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'
  get 'tutor/index', :to => 'tutor#index'
  get 'tutor/request_submission', to: 'tutor#request_submission' 
  get '/course_request', :to => 'course_request#index'
  get '/course_request/new', :to => 'course_request#new'
  get '/course_request/:id', :to => 'course_request#show'
  post '/course_request/delete_all_request', :to => 'course_request#delete_all_request', :as => :delete_all_request

  post '/spartan_sessions/check_in_first' => 'spartan_sessions#check_in_first'
  post '/spartan_sessions/check_in_second' => 'spartan_sessions#check_in_second'
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
  resources :tutor
  resources :course_request

end
