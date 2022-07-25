class GruposController < ApplicationController
  before_action :set_grupo, only: [:show, :edit, :update, :destroy, :usuarios, :apaga_acesso_usuario, :cria_acesso_usuario, :novo_acesso_usuario, :controle_acessos, :controle_acessos_edit, :controle_acessos_salvar]
  skip_before_action :verify_authenticity_token, only: [:controle_acessos_salvar, :controle_acessos_modelo_salvar]

  # GET /grupos
  # GET /grupos.json
  def index
    @grupos = Grupo.all.order(nome: :asc)

    @grupos = @grupos.where("lower(grupos.nome) ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @grupos = @grupos.where("lower(grupos.descricao) ilike '%#{params[:descricao].remove_injection}%'") if params[:descricao].present?
    if params[:usuario].present?
      @grupos = @grupos.joins("inner join grupo_usuarios on grupos.id = grupo_usuarios.grupo_id")
      @grupos = @grupos.joins("inner join usuarios on grupo_usuarios.usuario_id = usuarios.id")
      @grupos = @grupos.where("lower(usuarios.nome) ilike '%#{params[:usuario].remove_injection}%'")
    end

    if params[:perfil].present?
      @grupos = @grupos.joins("inner join grupo_usuarios on grupos.id = grupo_usuarios.grupo_id")
      @grupos = @grupos.joins("inner join usuarios on grupo_usuarios.usuario_id = usuarios.id")
      @grupos = @grupos.joins("inner join perfil_usuarios on perfil_usuarios.id = usuarios.perfil_usuario_id")
      @grupos = @grupos.where("perfil_usuarios.id = ? ", params[:perfil].to_i)
    end

    @grupos_total = @grupos.count
    options = {page: params[:page] || 1, per_page: 10}
    @grupos = @grupos.paginate(options)
  end

  # GET /grupos/1
  # GET /grupos/1.json
  def show
  end

  # GET /grupos/new
  def new
    @grupo = Grupo.new
  end

  # GET /grupos/#{@grupo.id}/edit
  def edit
  end

  def controle_acessos
    @grupo_registros = GrupoRegistro.where(grupo_id: @grupo.id)

    if params[:modelo].present?
      @grupo_registros = @grupo_registros.where(modelo: params[:modelo])
    end
    
    @grupo_registros = @grupo_registros.where("created_at >= ?", SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)) if params[:data_inicio].present?
    @grupo_registros = @grupo_registros.where("created_at <= ?", SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)) if params[:data_fim].present?
    
    @grupo_registros = @grupo_registros.order('created_at DESC')
    options = {page: params[:page] || 1, per_page: 10}
    @grupo_registros = @grupo_registros.paginate(options)
  end

  def controle_acessos_modelo
    @grupo_registros = GrupoRegistro.where(modelo_id: params[:modelo_id], modelo: params[:modelo])

    @grupo_registros = @grupo_registros.where("created_at >= ?", SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)) if params[:data_inicio].present?
    @grupo_registros = @grupo_registros.where("created_at <= ?", SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)) if params[:data_fim].present?
    
    @grupo_registros = @grupo_registros.order('created_at DESC')
    options = {page: params[:page] || 1, per_page: 10}
    @grupo_registros = @grupo_registros.paginate(options)
  end

  def controle_acessos_modelo_novo
    @registro = params[:modelo].constantize.find(params[:modelo_id])
  end

  def controle_acessos_modelo_salvar
    GrupoRegistro.create(modelo_id: params[:modelo_id], modelo: params[:modelo], grupo_id: params[:grupo_id])
    flash[:success] = "Registro alterado com sucesso"
    redirect_to "/controle-acessos/#{params[:modelo]}/#{params[:modelo_id]}/grupos"
  end

  def controle_acessos_modelo_delete
    GrupoRegistro.where(id: params[:grupo_registro_id]).destroy_all
    flash[:success] = "Registro apagado com sucesso"
    redirect_to "/controle-acessos/#{params[:modelo]}/#{params[:modelo_id]}/grupos"
  end

  def controle_acessos_edit
    @grupo_registro = GrupoRegistro.find(params[:grupo_registro_id])
  end

  def controle_acessos_salvar
    @grupo_registro = GrupoRegistro.find(params[:grupo_registro_id])
    @grupo_registro.grupo_id = params[:grupo_id_alterar]
    @grupo_registro.save!

    flash[:success] = "Registro alterado com sucesso"
    redirect_to "/grupos/#{@grupo_registro.grupo_id}/controle-acessos"
  end

  # POST /grupos
  # POST /grupos.json
  def create
    @grupo = Grupo.new(grupo_params)

    respond_to do |format|
      if @grupo.save
        format.html { redirect_to grupos_url, notice: 'Grupo foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @grupo }
      else
        format.html { render :new }
        format.json { render json: @grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grupos/1
  # PATCH/PUT /grupos/1.json
  def update
    respond_to do |format|
      if @grupo.update(grupo_params)
        format.html { redirect_to grupos_url, notice: 'Grupo foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @grupo }
      else
        format.html { render :edit }
        format.json { render json: @grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  def usuarios
    @grupo_usuarios = GrupoUsuario.where(grupo_id: @grupo.id)
    options = {page: params[:page] || 1, per_page: 10}
    @grupo_usuarios = @grupo_usuarios.paginate(options)
  end

  def apaga_acesso_usuario
    GrupoUsuario.where(usuario_id: params[:usuario_id], grupo_id: @grupo.id).destroy_all
    flash[:success] = "Acesso do usuário apagado com sucesso"
    redirect_to "/grupos/#{@grupo.id}/usuarios"
  end

  def cria_acesso_usuario
    @grupo_usuario = GrupoUsuario.new
    @grupo_usuario.usuario_id = params[:grupo_usuario][:usuario_id]
    @grupo_usuario.escrita = params[:grupo_usuario][:escrita] ? true : false
    @grupo_usuario.grupo_id = @grupo.id
    if !@grupo_usuario.save
      render :novo_acesso_usuario
      return
    end

    flash[:success] = "Acesso do usuário apagado com sucesso"
    redirect_to "/grupos/#{@grupo.id}/usuarios"
  end

  def novo_acesso_usuario
    @grupo_usuario = GrupoUsuario.new
  end

  # DELETE /grupos/1
  # DELETE /grupos/1.json
  def destroy
    @grupo.destroy
    respond_to do |format|
      format.html { redirect_to grupos_url, notice: 'Grupo foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_grupo
      @grupo = Grupo.find(params[:id] || params[:grupo_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grupo_params
      params.require(:grupo).permit(:nome, :pai, :descricao, :grupo_id)
    end
end
