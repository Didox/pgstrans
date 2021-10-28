class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]
  before_action :verifica_permissao, only: [:edit, :create, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:zerar_saldo, :create_api]
  
  # GET /usuarios
  # GET /usuarios.json
  def index
    @usuarios = Usuario.com_acesso(usuario_logado).order(nome: :asc)

    @usuarios = @usuarios.joins(:perfil_usuario)
    @usuarios = @usuarios.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @usuarios = @usuarios.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @usuarios = @usuarios.where("usuarios.email ilike '%#{params[:email].remove_injection}%'") if params[:email].present?
    @usuarios = @usuarios.where("usuarios.morada ilike '%#{params[:morada].remove_injection}%'") if params[:morada].present?
    @usuarios = @usuarios.where("usuarios.bairro ilike '%#{params[:bairro].remove_injection}%'") if params[:bairro].present?
    @usuarios = @usuarios.where("usuarios.telefone ilike '%#{params[:telefone].remove_injection}%'") if params[:telefone].present?
    @usuarios = @usuarios.where("usuarios.whatsapp ilike '%#{params[:whatsapp].remove_injection}%'") if params[:whatsapp].present?
    @usuarios = @usuarios.where("perfil_usuarios.admin = ?", params[:perfil_admin]) if params[:perfil_admin].present?
    @usuarios = @usuarios.where("perfil_usuarios.operador = ?", params[:perfil_operador]) if params[:perfil_operador].present?
    @usuarios = @usuarios.where("perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?
    @usuarios = @usuarios.where("municipio_id = ?", params[:municipio_id]) if params[:municipio_id].present?
    @usuarios = @usuarios.where("provincia_id = ?", params[:provincia_id]) if params[:provincia_id].present?
    @usuarios = @usuarios.where("uni_pessoal_empresa_id = ?", params[:uni_pessoal_empresa_id]) if params[:uni_pessoal_empresa_id].present?
    @usuarios = @usuarios.where("industry_id = ?", params[:industry_id]) if params[:industry_id].present?
    @usuarios = @usuarios.where("usuarios.id = ?", params[:id_interno]) if params[:id_interno].present?

    params[:status_cliente_id] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status_cliente_id)
    @usuarios = @usuarios.where("status_cliente_id = ?", params[:status_cliente_id]) if params[:status_cliente_id].present?

    if params[:grupo_id].present?
      @usuarios = @usuarios.joins("inner join grupo_usuarios on grupo_usuarios.usuario_id = usuarios.id").where("grupo_usuarios.grupo_id = ?", params[:grupo_id])
    end

    if params[:select_usuarios_not_self].present?
      if !usuario_logado.admin? && !usuario_logado.operador?
        @usuarios = @usuarios.where("usuarios.id not in (?)", usuario_logado.id)
      end
    end

    @usuarios = @usuarios.where("data_adesao >= ?", SqlDate.sql_parse(params[:data_adesao_inicio].to_datetime.beginning_of_day)) if params[:data_adesao_inicio].present?
    @usuarios = @usuarios.where("data_adesao <= ?", SqlDate.sql_parse(params[:data_adesao_fim].to_datetime.end_of_day)) if params[:data_adesao_fim].present?
    
    @usuarios = @usuarios.where(sub_agente_id: params[:sub_agente_id]) if params[:sub_agente_id].present?

    @usuarios_total = @usuarios.count

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

  def zerar_saldo
    usuario = Usuario.where(id: params[:usuario_id]).first
    if usuario.present?
      flash[:success] = "Saldo do usuário #{usuario.nome} zerado com sucesso !"
      
      conta_corrente = ContaCorrente.new
      if usuario.saldo > 0
        conta_corrente.valor = "-#{usuario.saldo.abs}"
        conta_corrente.lancamento = Lancamento.where(nome: Lancamento::DEBITO).first || Lancamento.first
        conta_corrente.observacao = "Zerando o saldo do usuário #{usuario.nome} (#{usuario.id})."
      else
        conta_corrente.valor = usuario.saldo.abs
        conta_corrente.lancamento = Lancamento.where(nome: Lancamento::CREDITO).first || Lancamento.first
        conta_corrente.observacao = "Regularizando o saldo do usuário #{usuario.nome} (#{usuario.id})."
      end

      conta_corrente.banco_id = Banco.order("ordem_prioridade asc").first.id
      conta_corrente.usuario = usuario
      conta_corrente.responsavel = usuario_logado
      conta_corrente.responsavel_aprovacao_id = usuario_logado.id
      conta_corrente.save!

      redirect_to "/conta_correntes/index_morada_saldo"
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
    @usuario = Usuario.new
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  # POST /usuarios.json
  def create_api
    create
  end

  def create
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
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    params[:usuario].delete(:senha) if params[:usuario] && params[:usuario][:senha].blank?

    respond_to do |format|
      if @usuario.update(usuario_params)
        salvar_grupos

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
      if !usuario_logado.admin? && !usuario_logado.operador? && !usuario_logado.agente?
        flash[:error] = "Área restrita. Digite o login e palavra-passe para entrar."
        redirect_to root_path
      end
    end

    
    def set_usuario
      @usuario = Usuario.find(params[:id])
      @usuario.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usuario_params
      if request.path_parameters[:format] == 'json'
        params.permit(:nome, :email, :senha, :perfil_usuario_id, 
          :sub_agente_id, :status_cliente_id, :morada, :bairro, :municipio_id, 
          :provincia_id, :industry_id, :uni_pessoal_empresa_id, :data_adesao, :telefone, :whatsapp)
      else
        params.require(:usuario).permit(:nome, :email, :senha, :perfil_usuario_id, 
          :sub_agente_id, :status_cliente_id, :morada, :bairro, :municipio_id, 
          :provincia_id, :industry_id, :uni_pessoal_empresa_id, :data_adesao, :telefone, :whatsapp)
      end
    end
end
