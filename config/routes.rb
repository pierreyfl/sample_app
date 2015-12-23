Rails.application.routes.draw do
  devise_for :users
  
  devise_scope :user do
    unauthenticated do
      root 'devise/sessions#new', as: :login_root
    end

    authenticated do
      root 'home#index'
    end
  end
  
  resources :account, only: [:index] do
    put :update, on: :collection
    member do
      get :request_access
      post :payment_setup
    end
  end
  resources :users, only: [:index, :show] do
    collection do
      get :search
      put :view_notifications
    end

    member do
      get :follow
      get :unfollow
    end

    resources :subscriptions, only: [:create] do
      delete :unsubscribe, on: :collection
    end
  end

  resources :microposts
  
  post '/callbacks/paypal_ipn' => 'callbacks#paypal_ipn', as: :paypal_ipn
end
