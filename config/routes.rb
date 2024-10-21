Rails.application.routes.draw do
  root "books#index"
  devise_for :users
  resources :authors
  resources :users, only: [:index] do
    get :favorite_books, on: :member
  end
  resources :books do
    put :favorite, on: :member
    collection do
      get :report
    end
  end
  get '/api' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      devise_for :users, skip: [:sessions, :passwords]
      as :user do
        post 'register', to: 'users#registration'
      end
      resources :users do
        collection do
          post :log_in
          post :log_out
        end
      end
    end
  end
end
