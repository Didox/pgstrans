Rails.application.routes.draw do
  resources :moedas
  get 'backoffice/home'
  resources :bancos
  resources :lancamentos
  resources :status_alegacao_pagamentos
  resources :tipo_transacaos
  resources :provincia
  resources :countries
  resources :canal_vendas
  resources :dispositivos
  resources :status_clientes
  resources :uni_pessoal_empresas
  resources :perfil_usuarios
  resources :remuneracaos
  resources :produtos
  resources :saldos
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
  post 'recarga/confirma', to: 'recarga#confirma', as: "recarga_confirma"

  resources :return_code_apis
  resources :query_balances
  resources :query_requests
  resources :topup_validations
  resources :matrix_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
