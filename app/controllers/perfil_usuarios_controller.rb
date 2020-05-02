class PerfilUsuariosController < ApplicationController
  before_action :set_perfil_usuario, only: [:show, :edit, :update, :destroy]

  # GET /perfil_usuarios
  # GET /perfil_usuarios.json
  def index
    @perfil_usuarios = PerfilUsuario.all.order(nome: :asc)
  end

  # GET /perfil_usuarios/1
  # GET /perfil_usuarios/1.json
  def show
  end

  # GET /perfil_usuarios/new
  def new
    @perfil_usuario = PerfilUsuario.new
    load_access
  end

  # GET /perfil_usuarios/1/edit
  def edit
    load_access
  end

  # POST /perfil_usuarios
  # POST /perfil_usuarios.json
  def create
    @perfil_usuario = PerfilUsuario.new(perfil_usuario_params)
    @perfil_usuario.acessos = parseAcesso

    respond_to do |format|
      if @perfil_usuario.save
        format.html { redirect_to @perfil_usuario, notice: 'Perfil de usuário foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @perfil_usuario }
      else
        format.html { render :new }
        format.json { render json: @perfil_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perfil_usuarios/1
  # PATCH/PUT /perfil_usuarios/1.json
  def update
    respond_to do |format|
      @perfil_usuario.update(perfil_usuario_params)
      @perfil_usuario.acessos = parseAcesso
      if @perfil_usuario.save
        format.html { redirect_to @perfil_usuario, notice: 'Perfil de usuário foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @perfil_usuario }
      else
        format.html { render :edit }
        format.json { render json: @perfil_usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perfil_usuarios/1
  # DELETE /perfil_usuarios/1.json
  def destroy
    @perfil_usuario.destroy
    respond_to do |format|
      format.html { redirect_to perfil_usuarios_url, notice: 'Perfil de usuário foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def parseAcesso
      acessos = []
      params["grupo_acesso"]["actions"].each do |acesso|
        views = params[:grupo_acesso][acesso.to_s.gsub("::", "_")]
        views ||= []
        acessos << {
          acesso: acesso,
          views: views
        }
      end

      acessos.to_json
    rescue
      "[]"
    end

    def load_access
      @controllers = []
      controllers = Rails.application.routes.routes.map{|route|route.defaults[:controller]}.uniq
      controllers.each do |controller|
        begin
          if !controller.include?("/") and !['login'].include?(controller)
            nome_controller = "#{controller}_controller".camelize;
            nome = nome_amigavel_controller(controller)
            if nome.present?
              actions = nome_controller.constantize.action_methods.collect{|a| a.to_s}
              actions_traduzido = []

              actions.each do |action|
                views = []

                nome_action = action_amigavel(action)
                if nome_action.present?
                  actions_traduzido << {
                    nome: action,
                    nome_amigavel: nome_action,
                    views: views
                  }
                end
              end

              @controllers << {
                nome_amigavel: nome,
                nome: nome_controller,
                actions: actions_traduzido
              }
            end
          end
        rescue;end
      end
    end

    def action_amigavel(action)
      nomes = {
        #new: "Mostrar tela de novo registro",
        #index: "Mostrar tela inicial",
        #update: "Atualizar registro",
        #create: "Criar registro",
        #destroy: "Apagar registro",
        #show: "Mostrar registro",
        #edit: "Mostrar tela de edição",
        new: "Mostrar a tela que permite a inclusão de novo registo",
        index: "Mostrar a lista de todos os registos",
        update: "Permitir a atualização de registo",
        create: "Pemitir a criação de novo registo",
        destroy: "Permitir apagar registo",
        show: "Permitir mostrar detalhes do registo",
        edit: "Permitir mostrar tela de edição do registo",
       }
      return nil if ["usuario_logado", "administrador"].include?(action)
      nomes[action.to_sym] || action
    end

    def nome_amigavel_controller(controller)
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
      nomes[controller.to_sym] || controller
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_perfil_usuario
      @perfil_usuario = PerfilUsuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def perfil_usuario_params
      params.require(:perfil_usuario).permit(:nome, :admin)
    end
end
