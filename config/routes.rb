# frozen_string_literal: true

Rails.application.routes.draw do
  post '/courses', :to => 'courses#create'
  get '/courses/index', :to => 'courses#index'
  get '/departments/index', :to => 'departments#index'
  post '/tutor/:id/edit', :to => 'tutor#update'
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'users#index'
  get '/users/index', :to => 'users#index'
  get '/users/schedule', :to => 'users#show_schedule', :as => :show_schedule
  get '/users/admin_view_hours', :to => 'users#admin_view_hours'
  post '/users/admin_view_hours', :to =>'users#output_admin_view_hours'
  get '/users/:id', :to => 'users#show', :as => :user
  post '/users/:id/delete_session', :to => 'users#delete_session', :as => :delete_session
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'

  post '/course_request/delete_all_request', :to => 'course_request#delete_all_request', :as => :delete_all_request


  post '/spartan_sessions/check_in_first' => 'spartan_sessions#check_in_first'
  post '/spartan_sessions/check_in_second' => 'spartan_sessions#check_in_second'
  get '/spartan_sessions/index', :to => 'spartan_sessions#index'
  post '/spartan_sessions/create', :to => 'spartan_sessions#create'
  post '/spartan_sessions/:id/edit_user', :to => 'spartan_sessions#edit_user'
  get '/spartan_sessions/:id/edit_user', :to => 'spartan_sessions#edit_user'
  post '/spartan_sessions/:id/update_attendance', :to => 'spartan_sessions#update_attendance'
  post '/spartan_sessions/:id/add_user', :to => 'spartan_sessions#add_user'
  post '/spartan_sessions/:id/download', :to => 'spartan_sessions#download'
  post '/spartan_sessions/:id/update', :to => 'spartan_sessions#update'
  post '/spartan_sessions/:id/delete', :to => 'spartan_sessions#delete'
  resources :spartan_sessions

  get '/notifications/:id', :to => 'notification#show'
  get '/tutoring_session/pending', :to => 'tutoring_session_user#show'
  get '/tutoring_session_user/:id/deny', :to => 'tutoring_session_user#deny_pending_link'
  get '/tutoring_session_user/:id/confirm', :to => 'tutoring_session_user#confirm_pending_link'
  get '/tutor/:id/course_edit', :to => 'tutor#course_edit'
  get '/tutor/:id/edit', :to => 'tutor#edit'
  get '/tutor/:id/show', :to => 'tutor#show'
  # TEMP UNTIL EMAIL
  get '/users/admin_view_hours', :to => 'users#admin_view_hours'
  post '/users/admin_view_hours', :to =>'users#admin_view_hours'
  get '/courses/new', :to => 'courses#new'

  #END TEMP
  resources :tutoring_session
  resources :users
  resources :tutor
  resources :departments
  resources :courses
  default_url_options :host => "localhost:3000"

end
