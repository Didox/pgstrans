Rails.application.routes.draw do
  resources :partners
  resources :topup_recargas
  root 'welcome#index'
  resources :return_code_apis
  resources :query_balances
  resources :query_requests
  resources :topup_validations
  resources :matrix_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
