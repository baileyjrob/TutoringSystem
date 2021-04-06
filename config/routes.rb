# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }
  root 'users#index'
  get '/users/index', :to => 'users#index'
  get '/users/schedule', :to => 'users#show_schedule', :as => :show_schedule
  get '/users/:id', :to => 'users#show', :as => :user
  post '/users/:id/delete_session', :to => 'users#delete_session', :as => :delete_session
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'
  get 'tutor/index', :to => 'tutor#index'
  get 'tutor/request_submission', to: 'tutor#request_submission' #, as: :submitted_request
  get '/course_request/index', :to => 'course_request#index'
  get 'course_request/:id', :to => 'course_request#show', :as => :request
  post '/course_request/new', :to => 'course_request#new'
  post '/course_request/delete_all_request', :to => 'course_request#delete_all_request', :as => :delete_all_request

  resources :tutoring_session
  resources :users
  resources :tutor
  resources :course_request

end
