Rails.application.routes.draw do
  resources :relatorio_conciliacao_zaptvs
  resources :status_parceiros
  resources :conta_correntes
  get 'vendas/resumido', to: 'vendas#resumido', as: "vendas_resumido"
  get 'vendas/:venda_id/resumido', to: 'vendas#mostrar_resumido', as: "vendas_mostrar_resumido"
  resources :vendas do
    delete '/reverter_venda_zaptv', to: 'vendas#reverter_venda_zaptv', as: "reverter_venda_zaptv"
  end
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
  root 'welcome#index'

  get 'login', to: 'login#index'
  get 'login', to: 'login#index'
  get 'logout', to: 'login#logout'
  post 'autentica', to: 'login#autentica'
  post 'recarga/confirma', to: 'recarga#confirma', as: "recarga_confirma"

  resources :return_code_apis
  resources :matrix_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
