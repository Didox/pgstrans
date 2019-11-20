class PerfilUsuariosController < ApplicationController
  before_action :set_perfil_usuario, only: [:show, :edit, :update, :destroy]

  # GET /perfil_usuarios
  # GET /perfil_usuarios.json
  def index
    @perfil_usuarios = PerfilUsuario.all
  end

  # GET /perfil_usuarios/1
  # GET /perfil_usuarios/1.json
  def show
  end

  # GET /perfil_usuarios/new
  def new
    @perfil_usuario = PerfilUsuario.new
  end

  # GET /perfil_usuarios/1/edit
  def edit
  end

  # POST /perfil_usuarios
  # POST /perfil_usuarios.json
  def create
    @perfil_usuario = PerfilUsuario.new(perfil_usuario_params)

    respond_to do |format|
      if @perfil_usuario.save
        format.html { redirect_to @perfil_usuario, notice: 'Perfil usuario was successfully created.' }
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
      if @perfil_usuario.update(perfil_usuario_params)
        format.html { redirect_to @perfil_usuario, notice: 'Perfil usuario was successfully updated.' }
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
      format.html { redirect_to perfil_usuarios_url, notice: 'Perfil usuario was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_perfil_usuario
      @perfil_usuario = PerfilUsuario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def perfil_usuario_params
      params.require(:perfil_usuario).permit(:nome, :admin)
    end
end
