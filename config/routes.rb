Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :admins, skip: [:passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :users, skip: [:passwards],  controllers: {
    registrations: "user/registrations",
    sessions: "user/sessions"
  }

  devise_scope :admin do
    get "/admins/sign_out" => "devise/sessions#destroy"
  end

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
    get "/users/sign_out" => "devise/sessions#destroy"
  end

  # ユーザー

  namespace :user do
    get "group_messages/new"
    get "group_messages/index"
  end

  scope module:  :user do
    root to: "homes#top"
    get "about" => "homes#about", as: "about"
    get "users/:id" => "users#show", as: "user"
    get "users/information/edit" => "users#edit"
    patch "users/information" => "users#update"
    get "/search", to: "searches#search"
    patch "notification/:id", to: "notifications#update", as: "notification"
    resources :reports, only: [:new, :create]

    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      get :followings
    end

    get "group_messages" => "group_messages#index"
    resources :groups, only: [:create, :new, :index, :show, :edit, :update, :destroy] do
      resource :group_users, only: [:create, :destroy]
      resources :group_messages, only: [:new, :create]
    end

    resources :users, only: [:show, :edit, :update] do
      resources :posts, only: [:index]
      resources :pets
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      member do
        get :favorites
        get :groups
      end
    end
  end

  # 管理者
  namespace :admin do
    get "/" => "homes#top"
    get "/search", to: "searches#search"
    resources :reports, only: [:index, :destroy]
    resources :posts, only: [:index, :show, :destroy]
    resources :users, only: [:index, :show, :edit, :update] do
      resources :posts, only: [:index]
    end
    resources :post_comments, only: [:index, :destroy]
  end
end
