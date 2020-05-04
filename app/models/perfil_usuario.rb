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
     }
    return nil if ["usuario_logado", "administrador"].include?(action)
    nomes[action.to_sym]
  end

  def self.nome_amigavel_controller(controller)
    nomes = {
      vendas: "Relatórios de Vendas",
      status_alegacao_pagamentos: "Situação de Alegação de Pagamento",
      parametros: "Parâmetros de Integração",
      unitel_sequences: "Controle de Sequência de Vendas da Unitel",
      relatorio_conciliacao_zaptvs: "Relatório de Reconciliação ZAP TV",
      status_parceiros: "Situação de Parceiros",
      conta_correntes: "Conta Corrente",
      moedas: "Tabela de Moedas",
      backoffice: "Menu de Serviços do Backoffice",
      bancos: "Tabela de Bancos",
      lancamentos: "Tipos de Lançamentos na Conta Corrente",
      tipo_transacaos: "Tipos de Transações",
      provincia: "Tabela de Províncias",
      countries: "Tabela de Países",
      canal_vendas: "Tabela de Canais de Venda",
      dispositivos: "Tabela de Dispositivos",
      status_clientes: "Tabela de Situação de Clientes",
      uni_pessoal_empresas: "Definição de Perfil de Cliente Unipessoal ou Empresa",
      perfil_usuarios: "Lista de Perfil de Usuários do Sistema",
      remuneracaos: "Tabela de Remunerações",
      produtos: "Tabela de Produtos",
      saldos: "Apresentação de Saldo",
      status_produtos: "Situação de Produtos",
      municipios: "Tabela de Municípios",
      industries: "Tabela de Actividades Económicas",
      usuarios: "Tabela de Usuários",
      sub_agentes: "Tabela de Subagentes",
      sub_distribuidors: "Tabela de Subdistribuidores",
      master_profiles: "Tabela de Perfil Master de Usuários",
      partners: "Parceiros",
      welcome: "Tela de Abertura",
      recarga: "Efectuar Recargas",
      return_code_apis: "Tabela de Código de Retorno das APIs por Parceiro",
      matrix_users: "Matriz de Usuários - Composição das Permissões e Associações"
    }
    nomes[controller.to_sym]
  end
end
