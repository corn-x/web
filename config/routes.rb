Rails.application.routes.draw do
  devise_for :users
  root to:"home#index"
  get '/auth/:provider/callback', to: 'auth#add_google_account'
  resources :teams do
    member do
      post 'members/add', to: 'teams#add_member'
      get 'invitation/accept', to: 'teams#accept_invitation'
      get 'invitation/reject', to: 'teams#reject_invitation'
    end
  end
end