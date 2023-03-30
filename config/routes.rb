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

  namespace :users do
    get   "mypage/profile/edit",        to: "mypage#edit_profile"
    patch "mypage/profile",             to: "mypage#update_profile"
    get   "mypage/spot_index",          to: "mypage#spot_index"
    get   "mypage/review_index",        to: "mypage#review_index"
    get   "mypage/image_index",         to: "mypage#image_index"
    get   "mypage/favorite_spot_index", to: "mypage#favorite_spot_index"
    get   "mypage/spot_tag_index",      to: "mypage#spot_tag_index"
  end

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
      resources :image_likes, only: [:create, :destroy]
    end

    resources :favorite_spots, only: [:create, :destroy]
    resources :spot_tags
  end
end
