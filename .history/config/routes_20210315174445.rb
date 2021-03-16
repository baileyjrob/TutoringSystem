# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'student#index'
  get 'student/index'
  get 'student/schedule'
  post 'student/schedule' => 'student#schedule_session'
  get '/users/:id', :to => 'users#show', :as => :user
  get '/users/schedule', :to => 'users#show_schedule', :as => :show_schedule
  post '/users/:id/delete_session' => 'users#delete_session', :as => :delete_session
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'
  #resources :student, only: [:index, :create, :destroy]
  #resources :student
  resources :tutoring_session
  resources :users
end
