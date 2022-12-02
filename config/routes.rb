Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
  }

  root  "pages#index"

  namespace :users do
    get   "mypage",       to: "profiles#index",  as: "mypage"
    get   "profile/edit", to: "profiles#edit",   as: "edit_profile"
    patch "profile",      to: "profiles#update", as: "profile"
    get   "spot_index",   to: "profiles#spot_index"
    get   "review_index", to: "profiles#review_index"
    get   "image_index",  to: "profiles#image_index"
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

    resources :reviews
    resources :images, only: [:index]
  end

  get "map_search",  to: "searchs#map_search"
  get "word_search", to: "searchs#word_search"
end
