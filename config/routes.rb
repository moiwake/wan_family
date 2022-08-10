Rails.application.routes.draw do
  devise_for :users, skip: [:registrations, :sessions, :passwords]
  devise_scope :user do
    get    "login",               to: "devise/sessions#new",          as: "login"
    post   "login",               to: "devise/sessions#create",       as: "create_login"
    delete "logout",              to: "devise/sessions#destroy",      as: "logout"
    get    "sign_up",             to: "devise/registrations#new",     as: "sign_up"
    post   "sign_up",             to: "devise/registrations#create",  as: "create_sign_up"
    get    "sign_up/cancel",      to: "devise/registrations#cancel",  as: "cancel_sign_up"
    get    "mypage/account/edit", to: "devise/registrations#edit",    as: "edit_account"
    patch  "mypage/account/",     to: "devise/registrations#update",  as: "update_account"
    put    "mypage/account/",     to: "devise/registrations#update"
    delete "mypage/account/",     to: "devise/registrations#destroy", as: "cancel_account"
    get    "password/new",        to: "devise/passwords#new",         as: "password"
    post   "password",            to: "devise/passwords#create",      as: "create_password"
    get    "password/edit",       to: "devise/passwords#edit",        as: "edit_password"
    patch  "password",            to: "devise/passwords#update",      as: "update_password"
    put    "password",            to: "devise/passwords#update"
  end

  root  "pages#index"
  get   "mypage",              to: "users#index" , as: "mypage"
  get   "mypage/profile/edit", to: "users#edit"  , as: "edit_profile"
  patch "mypage/profile"     , to: "users#update", as: "profile"
end
