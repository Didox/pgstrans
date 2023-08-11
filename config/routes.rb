Rails.application.routes.draw do
  resources :usuario_referencia_pagamentos
  resources :pagamento_referencias
  get 'painel_vendas/painel'
  get 'painel_vendas/index'
  resources :otp_key_africell_logs
  resources :modal_informativos
  resources :email_historico_envios
  resources :sms_historico_envios
  resources :ip_api_autorizados
  resources :alegacao_de_pagamentos do
    post '/processar', to: 'alegacao_de_pagamentos#processar'
  end

  resources :status_alegacao_de_pagamentos
  get 'vendas_conciliacao/index_vendas_conciliacao'
  get 'bancos_contas_bancarias/index_bancos_clientes'
  resources :status_bancos
  resources :logs
  resources :erro_amigavels
  resources :menus
  resources :movicel_loops do
    post '/processar', to: 'movicel_loops#processar'
    resources :loop_logs
  end
  
  get 'pagamentos_faturas_dstvs/resumido', to: 'pagamentos_faturas_dstvs#resumido'
  resources :pagamentos_faturas_dstvs

  get 'alteracoes_planos_dstvs/resumido', to: 'alteracoes_planos_dstvs#resumido'
  resources :alteracoes_planos_dstvs
  resources :log_vendas
  resources :sequencial_dstvs
  get 'dstv/validacao-cliente', to: 'dstv#validacao_cliente'
  # get 'dstv/consulta-fatura', to: 'dstv#consulta_fatura'
  get 'dstv/pagar-fatura', to: 'dstv#pagar_fatura'
  get 'dstv/alteracao-pacote', to: 'dstv#alteracao_pacote'
  get 'dstv/alteracao-cliente-produtos', to: 'dstv#alteracao_cliente_produtos'
  get 'dstv/alteracao-cliente-produtos/upgrade-downgrade', to: 'dstv#alteracao_pacote_fazer'
  # get 'dstv/alteracao-plano-mensal-anual', to: 'dstv#alteracao_plano_mensal_anual'
  get 'dstv/alteracao-plano-mensal-anual/alterar', to: 'dstv#alteracao_plano_mensal_anual_efetivar'

  resources :ende_uniq_numbers
  get 'ende/confirmar-cliente', to: 'ende#confirmar_cliente'
  get 'ende/venda-teste', to: 'ende#venda_teste'
  get 'ende/reprint', to: 'ende#reprint'
  get 'ende/last-advice', to: 'ende#last_advice'
  get 'ende/pagamento-de-conta', to: 'ende#pagamento_de_conta'
  
  get '/africell/impressao_recibo', to: 'africell#impressao_recibo'
  get '/africell/confirmacao_transacao', to: 'africell#confirmacao_transacao'

  get '/elephant_bet/consultar_voucher', to: 'elephant_bet#consultar_voucher'
  get '/elephant_bet/consultar_voucher/mini', to: 'elephant_bet#consultar_voucher_mini'

  get '/proxy_pay/pagamento_referencia', to: 'proxy_pay#pagamento_referencia'
  get '/proxy_pay/gerar_referencia', to: 'proxy_pay#gerar_referencia'
  get '/proxy_pay/apagar_referencia', to: 'proxy_pay#apagar_referencia'
  post '/webhook/conciliacao_proxy_pay', to: 'proxy_pay#conciliacao_proxy_pay'
  
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
  get 'conta_correntes/index_carregamento_usuario', to: 'conta_correntes#index_carregamento_usuario', as: "index_carregamento_usuario"
  get 'conta_correntes/conciliacao', to: 'conta_correntes#conciliacao', as: "conta_correntes_conciliacao"
  post 'conta_correntes/conciliacao/aplicar', to: 'conta_correntes#conciliacao_aplicar', as: "conta_correntes_conciliacao_aplicar"
  
  get 'conta_correntes/resumido', to: 'conta_correntes#conta_corrente_resumido'

  resources :conta_correntes
  get 'vendas/resumido', to: 'vendas#resumido', as: "vendas_resumido"
  get 'vendas/consolidado', to: 'vendas#consolidado', as: "consolidado"
  get 'vendas/:venda_id/resumido', to: 'vendas#mostrar_resumido', as: "vendas_mostrar_resumido"
  get 'vendas_grafico', to: 'vendas#index_grafico', as: "vendas_grafico"
  get 'vendas_resumo', to: 'vendas#index_resumo', as: "vendas_resumo"

  get 'africell/auth', to: 'africell#auth', as: "africell_auth"
  get 'google-auth', to: 'africell#google_auth', as: "africell_google_auth"

  get 'vendas-consolidado', to: 'vendas#consolidado', as: "vendas_consolidado"
  resources :vendas do
    delete '/reverter_venda_zaptv', to: 'vendas#reverter_venda_zaptv', as: "reverter_venda_zaptv"
    get '/recibo', to: 'vendas#recibo', as: "vendas_recibo"
    get '/mini', to: 'vendas#mini', as: "vendas_recibo_mini"
  end
  resources :moedas
  get 'backoffice/home'
  get 'backoffice/index'

  get 'bancos/index_bancos_clientes', to: 'bancos#index_bancos_clientes', as: "index_bancos_clientes"
  resources :bancos
 
  resources :lancamentos
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
  resources :return_code_apis
  resources :matrix_users

  get 'consulta-nome-usuario-operadora', to: 'usuarios#consulta_nome_usuario_operadora'

  resources :usuarios do
    get 'forcar-logout', to: 'usuarios#forcar_logout'
    post 'zerar_saldo', to: 'usuarios#zerar_saldo'
  end
  resources :sub_agentes
  resources :sub_distribuidors
  resources :master_profiles

  resources :partners do
    get 'zap-conciliacao', to: 'partners#zap_conciliacao'
    get 'importa_dados', to: 'partners#importa_dados'
    get 'importa_produtos', to: 'partners#importa_produtos'
    get 'atualiza_saldo', to: 'partners#atualiza_saldo'
    get 'atualiza_africell_login', to: 'partners#atualiza_africell_login'
    resources :desconto_parceiros
  end

  root 'welcome#index'

  mount SwaggerUiEngine::Engine, at: "/api_docs"

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
  get 'primeiro-acesso', to: 'login#primeiro_acesso'

  post 'api/usuarios/', to: 'usuarios#create_api'
  get 'api/usuarios/:id', to: 'usuarios#show_api'
  post 'api/login', to: 'login#autentica_api'
  post 'api/v2/login', to: 'login#autentica_api_v2'

  post 'api/recarga/confirma/:tipo_venda', to: 'recarga#confirma_api', as: "api_recarga_confirma"
  get 'api/recarga/dstv-produtos', to: 'dstv#produtos_api'
  get 'api/recarga/zap-produtos', to: 'produtos#produtos_zap_api'
  get 'api/recarga/movicel-produtos', to: 'produtos#produtos_movicel_api'
  get 'api/recarga/unitel-produtos', to: 'produtos#produtos_unitel_api'
  get 'api/recarga/ende-produtos', to: 'produtos#produtos_ende_api'
  get 'api/recarga/africell-produtos', to: 'produtos#produtos_africell_api'
  get 'api/recarga/zapfibra-produtos', to: 'produtos#produtos_zapfibra_api'
  get 'api/recarga/elephantbet-produtos', to: 'produtos#produtos_elephantbet_api'
  get 'api/recarga/bantubet-produtos', to: 'produtos#produtos_bantubet_api'

  post 'api/v2/recarga/confirma/:tipo_venda', to: 'recarga#confirma_api_v2', as: "api_recarga_confirma_v2"

  post 'api/alegacao_de_pagamentos/criar', to: 'alegacao_de_pagamentos#create_api'

  get 'api/conta-corrente/extrato', to: 'conta_correntes#index_api'

  get 'api/municipios', to: 'municipios#index_api'
  get 'api/provincias', to: 'provincia#index_api'
  get 'api/industries', to: 'industries#index_api'

  get 'api/dstv/validacao-cliente', to: 'dstv#validacao_cliente_api'

  # Rotas personalizadas para erros 404, 422 e 500
  get '/not_found', to: 'errors#not_found', code: 404
  get '/unprocessable_entity', to: 'errors#unprocessable_entity', code: 422
  get '/internal_server_error', to: 'errors#internal_server_error', code: 500

  # Rota curinga para capturar outros erros não tratados
  match "*path", to: "errors#not_found", via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end