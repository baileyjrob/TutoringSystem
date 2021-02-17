Rails.application.routes.draw do
  root 'landing#index'

  resources :tutoring_session
end
