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
  get 'tutor/request_submission'
  get 'tutor/index', :to => 'tutor#index'
  resources :tutoring_session
  resources :users
  resources :tutors

end
