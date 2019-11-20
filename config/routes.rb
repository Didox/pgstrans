Rails.application.routes.draw do
  resources :status_produtos
  resources :municipios
  resources :industries
  resources :usuarios
  resources :sub_agentes
  resources :sub_distribuidors
  resources :master_profiles
  resources :partners
  resources :topup_recargas
  root 'welcome#index'

  get 'login', to: 'login#index'
  get 'login', to: 'login#index'
  get 'logout', to: 'login#logout'
  post 'autentica', to: 'login#autentica'

  resources :return_code_apis
  resources :query_balances
  resources :query_requests
  resources :topup_validations
  resources :matrix_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
