# frozen_string_literal: true

Rails.application.routes.draw do
  get 'courses/my_courses'
  get 'departments/new'
  post 'departments/create'
  get 'departments/edit'
  get 'departments/show'
  get 'departments/index'
  get 'departments/delete'
  get 'departments/destroy'
  get 'courses/new'
  post 'courses/create'
  get 'courses/edit'
  get 'courses/show'
  get 'courses/index'
  get 'courses/delete'
  get 'courses/destroy'
  post '/tutor/:id/edit', :to => 'tutor#edit'
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'users#index'
  get '/users/index', :to => 'users#index'
  post '/users', :to => 'users#index'
  get '/users/schedule', :to => 'users#show_schedule', :as => :show_schedule
  get '/users/admin_view_hours', :to => 'users#admin_view_hours'
  post '/users/admin_view_hours', :to =>'users#output_admin_view_hours'
  get '/users/:id', :to => 'users#show', :as => :user
  post '/users/:id/delete_session', :to => 'users#delete_session', :as => :delete_session
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'

  get '/course_request', :to => 'course_request#index'
  get '/course_request/new', :to => 'course_request#new'
  get '/course_request/:id', :to => 'course_request#show'
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
  get '/tutor/:id/course_index', :to => 'tutor#course_index'
  get '/tutor/:id/course_edit', :to => 'tutor#course_edit'
  get '/tutor/:id/course_new', :to => 'tutor#course_new'
  get '/tutor/:id/edit', :to => 'tutor#edit'
  # TEMP UNTIL EMAIL
  get '/users/admin_view_hours', :to => 'users#admin_view_hours'
  post '/users/admin_view_hours', :to =>'users#admin_view_hours'
  #END TEMP
  resources :tutoring_session
  resources :users
  resources :tutor do
    member do
      post :edit
    end
  end
  default_url_options :host => "localhost:3000"

end
