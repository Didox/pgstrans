class PerfilUsuariosController < ApplicationController
  before_action :set_perfil_usuario, only: [:show, :edit, :update, :destroy]

  # GET /perfil_usuarios
  # GET /perfil_usuarios.json
  def index
    @perfil_usuarios = PerfilUsuario.all.order(nome: :asc)

    @perfil_usuarios = @perfil_usuarios.where("nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @perfil_usuarios = @perfil_usuarios.where("admin = ?", params[:perfil_admin]) if params[:perfil_admin].present?
    @perfil_usuarios = @perfil_usuarios.where("operador = ?", params[:perfil_operador]) if params[:perfil_operador].present?

    options = {page: params[:page] || 1, per_page: 10}
    @perfil_usuarios = @perfil_usuarios.paginate(options)
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
    @perfil_usuario.acessos = parse_acesso
    @perfil_usuario.links_externos = parseLink_acessos

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
      @perfil_usuario.acessos = parse_acesso
      @perfil_usuario.links_externos = parse_link_acessos

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
    def parse_link_acessos
      params[:links_externos].join(",") rescue ""
    end

    def parse_acesso
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

      @controllers << {
        nome_amigavel: "Acesso à documentação da API",
        nome: "SwaggerUiEngine::SwaggerDocsController",
        actions: [
          {
            nome: "index",
            nome_amigavel: "Doc API",
            views: []
          },
          {
            nome: "single_doc",
            nome_amigavel: "Página principal Doc API",
            views: []
          },
          {
            nome: "show",
            nome_amigavel: "Mostrar item API",
            views: []
          }
        ]
      }

      controllers = Rails.application.routes.routes.map{|route|route.defaults[:controller]}.uniq
      controllers.each do |controller|
        begin
          if !controller.include?("/") and !['login'].include?(controller)
            nome_controller = "#{controller}_controller".camelize;
            nome = PerfilUsuario.nome_amigavel_controller(controller)
            if nome.present?
              actions = nome_controller.constantize.action_methods.collect{|a| a.to_s}
              actions_traduzido = []

              actions.each do |action|
                views = []

                nome_action = PerfilUsuario.action_amigavel(action)
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

    def set_perfil_usuario
      @perfil_usuario = PerfilUsuario.find(params[:id] || params[:perfil_usuario_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def perfil_usuario_params
      params.require(:perfil_usuario).permit(:nome, :admin, :operador, :agente)
    end
end
