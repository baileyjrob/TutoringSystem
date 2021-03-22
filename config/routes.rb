# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'student#index'
  get 'student/index' => 'tutor#student_index'
  get 'student/schedule'
  post 'student/schedule' => 'student#schedule_session'
  get '/users/:id', :to => 'users#show', :as => :user
  get 'tutor/index'
  post 'tutor/index' => 'student#matching_index'
  get 'tutor/request_submission'
  get '/users/tutor_matching', :to=>'users#tutor_matching'
  get '/users/course_req_submission', :to=> 'users#course_req_submission'
  get '/users/:id/schedule_student', :to => 'users#schedule_student'
  post '/users/:id/schedule_session_student' => 'users#schedule_session_student'
  #resources :student, only: [:index, :create, :destroy]
  #resources :student
  resources :tutoring_session
  resources :user

end
