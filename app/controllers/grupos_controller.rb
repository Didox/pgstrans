class GruposController < ApplicationController
  before_action :set_grupo, only: [:show, :edit, :update, :destroy, :usuarios, :apaga_acesso_usuario, :cria_acesso_usuario, :novo_acesso_usuario]
  
  # GET /grupos
  # GET /grupos.json
  def index
    @grupos = Grupo.all.order(nome: :asc)

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

  # GET /grupos/1/edit
  def edit
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
    @usuarios = Usuario.joins(:grupo_usuarios).where("grupo_id=#{@grupo.id}").distinct
    options = {page: params[:page] || 1, per_page: 10}
    @usuarios = @usuarios.paginate(options)
  end

  def apaga_acesso_usuario
    GrupoUsuario.where(usuario_id: params[:usuario_id], grupo_id: @grupo.id).destroy_all
    flash[:success] = "Acesso do usuário apagado com sucesso"
    redirect_to "/grupos/1/usuarios"
  end

  def cria_acesso_usuario
    @grupo_usuario = GrupoUsuario.new
    @grupo_usuario.usuario_id = params[:grupo_usuario][:usuario_id]
    @grupo_usuario.grupo_id = @grupo.id
    if !@grupo_usuario.save
      render :novo_acesso_usuario
      return
    end

    flash[:success] = "Acesso do usuário apagado com sucesso"
    redirect_to "/grupos/1/usuarios"
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
    # Use callbacks to share common setup or constraints between actions.
    def set_grupo
      @grupo = Grupo.find(params[:id] || params[:grupo_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grupo_params
      params.require(:grupo).permit(:nome, :pai, :descricao, :grupo_id)
    end
end
