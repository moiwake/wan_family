Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root "top#index"
  get  "map_search",  to: "top#map_search"
  get  "word_search", to: "top#word_search"

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
  }

  get   "mypage",             to: "users#index",  as: "mypage"
  get   "profile/edit",       to: "users#edit",   as: "edit_profile"
  patch "profile",            to: "users#update", as: "profile"
  get   "users_spot_index",   to: "users#spot_index"
  get   "users_review_index", to: "users#review_index"
  get   "users_image_index",  to: "users#image_index"

  resources :spots, except: :destroy do
    collection do
      get  "new_confirm",   action: "new_confirm"
      post "new_confirm",   action: "new_confirm"
      get  "back_new",      action: "back_new"
      post "back_new",      action: "back_new"
    end

    member do
      get   "edit_confirm", action: "edit_confirm"
      patch "edit_confirm", action: "edit_confirm"
      get   "back_edit",    action: "back_edit"
      patch "back_edit",    action: "back_edit"
    end

    resources :reviews do
      resources :like_reviews, only: [:create, :destroy]
    end

    resources :images, only: [:index, :show] do
      resources :like_images, only: [:create, :destroy]
    end
  end
end
