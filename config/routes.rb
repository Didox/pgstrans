Rails.application.routes.draw do
  resources :log_vendas
  resources :sequencial_dstvs
  get 'dstv/validacao-cliente', to: 'dstv#validacao_cliente'
  get 'dstv/consulta-fatura', to: 'dstv#consulta_fatura'
  get 'dstv/pagar-fatura', to: 'dstv#pagar_fatura'
  get 'dstv/alteracao-pacote', to: 'dstv#alteracao_pacote'
  get 'dstv/alteracao-cliente-produtos', to: 'dstv#alteracao_cliente_produtos'
  get 'dstv/alteracao-cliente-produtos/upgrade-downgrade', to: 'dstv#alteracao_plano'

  resources :grupos do
    get 'usuarios', to: 'grupos#usuarios'
    delete 'usuarios/:usuario_id', to: 'grupos#apaga_acesso_usuario'
    post 'usuarios', to: 'grupos#cria_acesso_usuario'
    get 'usuarios/new', to: 'grupos#novo_acesso_usuario'
  end
  resources :parametros
  resources :unitel_sequences
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
  get 'backoffice/index'
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

  resources :partners do
    get 'importa_dados', to: 'partners#importa_dados'
    get 'importa_produtos', to: 'partners#importa_produtos'
    get 'atualiza_saldo', to: 'partners#atualiza_saldo'
  end

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
