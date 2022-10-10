Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions:      'admins/sessions'
  }

  devise_for :users, skip: [:registrations, :sessions, :passwords]
  devise_scope :user do
    get    "login",               to: "users/sessions#new",          as: "login"
    post   "login",               to: "users/sessions#create",       as: "create_login"
    delete "logout",              to: "users/sessions#destroy",      as: "logout"
    get    "sign_up",             to: "users/registrations#new",     as: "sign_up"
    post   "sign_up",             to: "users/registrations#create",  as: "create_sign_up"
    get    "sign_up/cancel",      to: "users/registrations#cancel",  as: "cancel_sign_up"
    get    "mypage/account/edit", to: "users/registrations#edit",    as: "edit_account"
    patch  "mypage/account/",     to: "users/registrations#update",  as: "update_account"
    put    "mypage/account/",     to: "users/registrations#update"
    delete "mypage/account/",     to: "users/registrations#destroy", as: "cancel_account"
    get    "password/new",        to: "users/passwords#new",         as: "password"
    post   "password",            to: "users/passwords#create",      as: "create_password"
    get    "password/edit",       to: "users/passwords#edit",        as: "edit_password"
    patch  "password",            to: "users/passwords#update",      as: "update_password"
    put    "password",            to: "users/passwords#update"
  end

  root  "pages#index"
  get   "mypage",              to: "users#index",  as: "mypage"
  get   "mypage/profile/edit", to: "users#edit",   as: "edit_profile"
  patch "mypage/profile",      to: "users#update", as: "profile"
end
