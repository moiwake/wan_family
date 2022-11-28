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
    get   "mypage",              to: "profiles#index",  as: "mypage"
    get   "mypage/profile/edit", to: "profiles#edit",   as: "edit_profile"
    patch "mypage/profile",      to: "profiles#update", as: "profile"
  end

  namespace :spots do
    resources :registrations do
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
    end

    resources :searchs
  end

  resources :reviews
end
