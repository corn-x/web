Rails.application.routes.draw do
  devise_for :users
  root to:"home#index"
  get '/auth/:provider/callback', to: 'auth#add_google_account'
end