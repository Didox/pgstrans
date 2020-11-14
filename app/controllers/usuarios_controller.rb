class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]
  before_action :verifica_permissao, only: [:edit, :create, :update, :destroy]
  # GET /usuarios
  # GET /usuarios.json
  def index
    #@usuarios = Usuario.all.order(nome: :asc)
    @usuarios = Usuario.com_acesso(usuario_logado).order(nome: :asc)

    @usuarios = @usuarios.joins(:perfil_usuario)
    @usuarios = @usuarios.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    @usuarios = @usuarios.where("usuarios.login ilike '%#{params[:login]}%'") if params[:login].present?
    @usuarios = @usuarios.where("usuarios.email ilike '%#{params[:email]}%'") if params[:email].present?
    @usuarios = @usuarios.where("perfil_usuarios.admin = ?", params[:perfil_admin]) if params[:perfil_admin].present?
    @usuarios = @usuarios.where("perfil_usuarios.operador = ?", params[:perfil_operador]) if params[:perfil_operador].present?
    @usuarios = @usuarios.where("perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?
    @usuarios = @usuarios.where(sub_agente_id: params[:sub_agente_id]) if params[:sub_agente_id].present?

    options = {page: params[:page] || 1, per_page: 10}
    @usuarios = @usuarios.paginate(options)
  end

  def forcar_logout
    usuarios = Usuario.where(id: params[:usuario_id])
    if(usuarios.count > 0)
      flash[:success] = "Forçar logout do usuário #{usuarios.first.nome} executado com sucesso !"
      usuarios.update_all(logado: false)
      redirect_to usuarios_path
      return
    end

    flash[:error] = "Usuário não localizado"
    redirect_to usuarios_path
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    if(usuario_logado.admin? || usuario_logado.operador?)
      @usuario = Usuario.new
    else
      redirect_to usuarios_path
    end
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    if(usuario_logado.admin? || usuario_logado.operador?)
      @usuario = Usuario.new(usuario_params)
      @usuario.responsavel = usuario_logado
      
      respond_to do |format|
        if @usuario.save
          salvar_grupos
          format.html { redirect_to @usuario, notice: 'Usuário foi criado com sucesso.' }
          format.json { render :show, status: :created, location: @usuario }
        else
          format.html { render :new }
          format.json { render json: @usuario.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to usuarios_path
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        salvar_grupos

        if usuario_params[:senha].present?
          usuarios = Usuario.where(id: @usuario.id)
          usuarios.update_all(logado: false)
        end

        format.html { redirect_to @usuario, notice: 'Usuário foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: 'Usuário foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::InvalidForeignKey => erro
    flash[:error] = "Usuário não pode ser excluído porque tem vínculos que precisam ser apagados ou desfeitos."
    respond_to do |format|
      format.html { redirect_to usuarios_url }
      format.json { head :no_content }
    end
  end

  private
    def salvar_grupos
      GrupoUsuario.where(usuario_id: @usuario.id).destroy_all
      if params[:grupos].present?
        params[:grupos].each do |grupo|
          GrupoUsuario.create(usuario_id: @usuario.id, grupo_id: grupo)
        end
      end
    end

    def verifica_permissao
      if !usuario_logado.admin? && !usuario_logado.operador?
        flash[:error] = "Área restrita. Digite o login e palavra-passe para entrar."
        redirect_to root_path
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
      @usuario.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      params.require(:usuario).permit(:nome, :email, :senha, :perfil_usuario_id, :sub_agente_id, :status_cliente_id, :morada, :bairro, :municipio_id, :provincia_id, :industry_id, :uni_pessoal_empresa_id)
    end
end
