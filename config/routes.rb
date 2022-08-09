Rails.application.routes.draw do
  devise_for :users, path_names: {
    users: "account",
    sign_in: "login",
    sign_out: "logout",
  }

  root 'pages#index'
  get   "profile/edit", to: "users#edit"  , as: "profile_edit"
  patch "profile"     , to: "users#update", as: "profile"
end
