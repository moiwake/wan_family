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

  get   "mypage",              to: "users#index",  as: "mypage"
  get   "mypage/profile/edit", to: "users#edit",   as: "edit_profile"
  patch "mypage/profile",      to: "users#update", as: "profile"

  resources :spots do
    collection do
      post "new_confirm", action: "new_confirm"
      post "back_new",    action: "back_new"
    end

    member do
      patch "edit_confirm", action: "edit_confirm"
      patch "back_edit",    action: "back_edit"
    end
  end
end
