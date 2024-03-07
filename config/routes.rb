Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  devise_for :users,skip: [:passwards],  controllers: {
    registrations: "user/registrations",
    sessions: 'user/sessions'
  }

  devise_scope :admin do
    get '/admin/sign_out' => 'devise/sessions#destroy'
  end

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # ユーザー
  scope module:  :user do
    root to: "homes#top"
    get "about" => 'homes#about', as: 'about'
    get "users/my_page" => "users#show"
    get "users/information/edit" => "users#edit"
    patch "users/information" => "users#update"
    get "/search", to: "searches#search"
    resources :pets, only: [:index, :update, :destroy, :create, :edit, :show ,:new]
    
    resources :posts, only: [:create, :new, :index, :show, :edit, :destroy, :update] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end

    resources :groups, only: [:create, :new, :index, :show, :edit, :update] do
      resource :group_users, only: [:create, :destroy]
    end

    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get "followings" =>"relationships#followings", as: "followings"
      get "followers" =>"relationships#followers", as: "followers"
    end
    
  end

  # 管理者
    namespace :admin do
    get "/" => 'homes#top'
    resources :posts, only: [:index, :show]
    resources :users, only: [:index, :show, :edit]
  end
end
