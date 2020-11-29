Rails.application.routes.draw do
  resources :movicel_loops
  resources :pagamentos_faturas_dstvs
  resources :alteracoes_planos_dstvs
  resources :log_vendas
  resources :sequencial_dstvs
  get 'dstv/validacao-cliente', to: 'dstv#validacao_cliente'
  get 'dstv/consulta-fatura', to: 'dstv#consulta_fatura'
  get 'dstv/pagar-fatura', to: 'dstv#pagar_fatura'
  get 'dstv/alteracao-pacote', to: 'dstv#alteracao_pacote'
  get 'dstv/alteracao-cliente-produtos', to: 'dstv#alteracao_cliente_produtos'
  get 'dstv/alteracao-cliente-produtos/upgrade-downgrade', to: 'dstv#alteracao_plano'
  get 'dstv/alteracao-plano-mensal-anual', to: 'dstv#alteracao_plano_mensal_anual'
  get 'dstv/alteracao-plano-mensal-anual/alterar', to: 'dstv#alteracao_plano_mensal_anual_efetivar'

  get '/controle-acessos/:modelo/:modelo_id/grupos', to: 'grupos#controle_acessos_modelo'
  get '/controle-acessos/:modelo/:modelo_id/grupos/novo', to: 'grupos#controle_acessos_modelo_novo'
  post '/controle-acessos/:modelo/:modelo_id/grupos/salvar', to: 'grupos#controle_acessos_modelo_salvar'
  delete '/controle-acessos/:modelo/:modelo_id/grupos/:grupo_registro_id/delete', to: 'grupos#controle_acessos_modelo_delete'
  
  put '/grupo_usuarios/:grupo_usuario_id', to: 'grupo_usuarios#update'

  resources :grupos do
    get 'usuarios', tox: 'grupos#usuarios'
    delete 'usuarios/:usuario_id', to: 'grupos#apaga_acesso_usuario'
    post 'usuarios', to: 'grupos#cria_acesso_usuario'
    get 'usuarios/new', to: 'grupos#novo_acesso_usuario'
    get 'controle-acessos', to: 'grupos#controle_acessos'
    get 'controle-acessos/:grupo_registro_id/edit', to: 'grupos#controle_acessos_edit'
    post 'controle-acessos/:grupo_registro_id/alterar', to: 'grupos#controle_acessos_salvar'
  end
  resources :parametros
  resources :unitel_sequences
  resources :relatorio_conciliacao_zaptvs
  resources :status_parceiros
  get 'conta_correntes/index_morada_saldo', to: 'conta_correntes#index_morada_saldo', as: "index_morada_saldo"
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
  resources :usuarios do
    get 'forcar-logout', tox: 'usuarios#forcar_logout'
  end
  resources :sub_agentes
  resources :sub_distribuidors
  resources :master_profiles

  resources :partners do
    get 'importa_dados', to: 'partners#importa_dados'
    get 'importa_produtos', to: 'partners#importa_produtos'
    get 'atualiza_saldo', to: 'partners#atualiza_saldo'
    resources :desconto_parceiros
  end

  root 'welcome#index'

  get 'descontos', to: 'descontos#index'
  get 'descontos/lucros', to: 'descontos#lucros', as: "descontos_lucros"

  get 'login', to: 'login#index'
  get 'login', to: 'login#index'
  get 'logout', to: 'login#logout'
  post 'autentica', to: 'login#autentica'
  post 'recarga/confirma', to: 'recarga#confirma', as: "recarga_confirma"

  get 'alterar-senha', to: 'login#alterar_senha'
  post 'alterar-senha', to: 'login#mudar_senha'
  get 'password-esquecida', to: 'login#password_esquecida'
  post 'password-esquecida', to: 'login#recuperar_password_esquecida'
  
  resources :return_code_apis
  resources :matrix_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end