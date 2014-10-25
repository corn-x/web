Rails.application.routes.draw do
  root to:"home#index"
  get '/auth/:provider/callback', to: 'auth#add_google_account'

  scope :api, defaults: {format: :json} do
    scope :v1, defaults: {format: :json} do
      devise_for :users
      resources :teams do
        member do
          post 'members/add', to: 'teams#add_member'
          get 'invitation/accept', to: 'teams#accept_invitation'
          get 'invitation/reject', to: 'teams#reject_invitation'
          get 'meetings'
        end
        collection do
          get 'my'
        end
      end
      resources :meetings do
        member do
          get 'stats'
        end
        collection do
          get 'my'
        end
      end
    end
  end
end