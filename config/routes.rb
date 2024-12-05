Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root "books#index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  resources :csv_uploads
  resources :authors
  resources :categories
  resources :users, only: [:index] do
    get :favorite_books, on: :member
  end
  resources :books do
    put :favorite, on: :member
    collection do
      get :report
    end
  end
  get 'chats', to: 'chats#index'
  get '/conversation/:id', to: 'chats#conversation', as: 'conversation'
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
