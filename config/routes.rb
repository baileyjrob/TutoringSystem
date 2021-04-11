# frozen_string_literal: true

Rails.application.routes.draw do
  get 'departments/new', :to => 'departments#new'
  get 'departments/index', :to => 'departments#index'
  get 'departments/:id/show', :to => 'departments#show'
  get 'departments/:id/edit', :to => 'departments#edit'
  post 'departments/create', :to => 'departments#create'
  get 'courses/new'
  get 'courses/index'
  get 'courses/show'
  get 'courses/edit'
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
