Rails.application.routes.draw do
  devise_scope :user do
    get 'login', to: 'users/sessions#new', as: :new_user_session
    post 'login', to: 'users/sessions#create', as: :user_session
    delete 'logout', to: 'users/sessions#destroy', as: :destroy_user_session
    get 'signup', to: 'users/registrations#new', as: :new_user_registration
    post 'signup', to: 'users/registrations#create', as: :user_registration
    get 'password', to: 'users/passwords#new', as: :new_user_password
  end

  root 'pages#index'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
