class PerfilUsuario < ApplicationRecord
  validates :nome, presence: true, uniqueness: true

  def acessos_parse
    self.acessos.present? ? JSON.parse(self.acessos) : []
  rescue
	 []
  end

  def acessos_actions
    acessos_parse.map{|a|a["acesso"]}
  rescue
    []
  end

  def acessos_views
    acessos_parse.map{|a|a["views"]}.uniq.compact.flatten
  rescue
    []
  end

  def self.tem_acesso?(administrador, controller, action)
    return administrador.acessos.include? "#{controller}::#{action}"
  rescue
    false
  end

  def self.action_amigavel(action)
    nomes = {
      new: "Mostrar a tela que permite a inclusão de novo registo",
      index: "Mostrar a lista de todos os registos",
      update: "Permitir a atualização de registo",
      create: "Pemitir a criação de novo registo",
      destroy: "Permitir apagar registo",
      show: "Permitir mostrar detalhes do registo",
      edit: "Permitir mostrar tela de edição do registo",
      atualiza_saldo: "Fazer consulta de saldo no parceiro, caso o parceiro ofereça esse serviço",
      confirma: "Confirmar envio recarga / submissão de pagamento",
      usuarios: "Usuários",
      apaga_acesso_usuario: "Apaga grupo de acesso de usuário",
      cria_acesso_usuario: "Cria grupo de acesso de usuário",
      novo_acesso_usuario: "Tela de criação de novo acesso do usuário",
      resumido: "Tela de vendas resumidas por usuário / Vendas do perfil",
      importa_produtos: "Acesso ao botão 'Atualizar portfólio de produtos ZAP'",
      importa_dados: "Acesso ao botão 'Importar dados para relatório de conciliação ZAP'",
      validacao_cliente: "Validação e consulta da situação do cliente",
      consulta_fatura: "Consulta valor e data do vencimento da fatura",
      alteracao_pacote: "Alteração de pacote de produtos",
      alteracao_plano: "Alteração de plano",
      alteracao_plano_mensal_anual: "Alteração de plano de cobrança alternando entre mensal e anual",
      alteracao_plano_mensal_anual_efetivar: "Alteração de plano de cobrança alternando entre mensal e anual (Efetivar)",
      alteracao_cliente_produtos: "Listagem de produtos em validação de pagamento DSTV",
      pagar_fatura: "Pagar fatura DSTV",
      reverter_venda_zaptv: "Reverter Vendas DSTV",
      index_morada_saldo: "Ver relatório Conta corrente - Usuário Morada Saldo",
      forcar_logout: "Habilitar permissão para deslogar usuário (forçar logout após troca de senha)"
     }
    return nil if ["usuario_logado", "administrador"].include?(action)
    nomes[action.to_sym]
  end

  def self.nome_amigavel_controller(controller)
    nomes = {
      vendas: "Backoffice - Vendas",
      status_alegacao_pagamentos: "Backoffice - Conta Corrente - Situação de Alegação de Pagamento",
      parametros: "Backoffice - Transações - Parâmetros de Integração",
      unitel_sequences: "Backoffice - Transações - Controle de Sequência de Vendas da Unitel",
      relatorio_conciliacao_zaptvs: "Backoffice - Parceiros - Relatório de Reconciliação ZAPTV",
      status_parceiros: "Backoffice - Parceiros/Produtos - Situação de Parceiros",
      conta_correntes: "Backoffice - Conta Corrente - Conta Corrente",
      moedas: "Backoffice - Tabelas Auxiliares - Moedas",
      backoffice: "Menu Principal de Serviços do Backoffice",
      bancos: "Backoffice - Conta Corrente - Lista de Bancos",
      lancamentos: "Backoffice - Conta Corrente - Tipos de Lançamentos",
      tipo_transacaos: "Backoffice - Transações - Tipos de Transações",
      provincia: "Backoffice - Tabelas Auxiliares - Províncias",
      countries: "Backoffice - Tabelas Auxiliares - Países",
      canal_vendas: "Backoffice - Tabelas Auxiliares - Canais de Venda",
      dispositivos: "Backoffice - Tabelas Auxiliares - Dispositivos",
      status_clientes: "Backoffice - Usuários Clientes - Situação de Clientes",
      uni_pessoal_empresas: "Backoffice - Usuários/Clientes - Cliente Unipessoal ou Empresa",
      perfil_usuarios: "Backoffice - Usuários/Clientes - Usuários do Sistema",
      remuneracaos: "Backoffice - Remuneração Margem - Remuneraçção Clientes",
      produtos: "Backoffice - Parceiros/Produtos - Produtos",
      status_produtos: "Backoffice - Parceiros/Produtos - Situação de Produtos",
      saldos: "Tela de movimentação do própio saldo e de acordo com o perfil do usuário",
      municipios: "Backoffice - Tabelas Auxiliares - Municípios",
      industries: "Backoffice - Tabelas Auxiliares - Actividades Económicas",
      usuarios: "Backoffice - Usuarios/Clientes - Tabela de Usuários",
      sub_agentes: "Backoffice - Usuários/Clientes - Subagentes",
      sub_distribuidors: "Backoffice - Usuários/Clientes - Subdistribuidores",
      master_profiles: "Backoffice - Usuários/Clientes - Perfil Master de Negócio Usuário",
      partners: "Backoffice - Parceiros/Produtos - Parceiros",
      welcome: "Tela de Abertura do Backoffice",
      recarga: "Acesso ao menu de vendas para efectuar recargas / submeter pagamento (fazer venda)",
      return_code_apis: "Backoffice - Transações - Código de Retorno das APIs por Parceiro",
      matrix_users: "Backoffice - Usuários/Clientes - Matriz de Usuários",
      grupos: "Grupos de acesso e Acessos aos registros do sistema",
      dstv: "DSTV ações",
      sequencial_dstvs: "Backoffice - Transações - Controle de Sequência de Vendas da DSTV",
      log_vendas: "Log de vendas não realizadas",
      pagamentos_faturas_dstvs: "Pagamentos de fatura DSTV",
      alteracoes_planos_dstvs: "Alteração de planos DSTV",
    }
    nomes[controller.to_sym]
  end
end
