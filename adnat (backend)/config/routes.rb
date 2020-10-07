Rails.application.routes.draw do
  namespace :api do
    post '/auths', to: 'user_token#create'

    resources :organisations, only: [:index, :show, :create, :update] do
      get '/users', to: 'organisations#index_associated_users'
    end

    resources :users, only: [:index, :show, :create, :update, :destroy] do
      get '/organisations', to: 'users#index_associated_organisations'

      get '/shifts', to: 'shifts#index_for_user'
      post '/shifts', to: 'shifts#create_for_user'

      post '/organisations/:organisation_id', to: 'users#join_organisation'
      delete '/organisations/:organisation_id', to: 'users#leave_organisation'
    end

    resources :shifts, only: [:index, :show, :update, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
