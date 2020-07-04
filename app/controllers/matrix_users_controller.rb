class MatrixUsersController < ApplicationController
  before_action :set_matrix_user, only: [:show, :edit, :update, :destroy]

  # GET /matrix_users
  # GET /matrix_users.json
  def index
    @matrix_users = MatrixUser.com_acesso(usuario_logado).order(usuario_id: :asc)  

    @matrix_users = @matrix_users.joins(:usuario)
    @matrix_users = @matrix_users.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    @matrix_users = @matrix_users.where("matrix_users.master_profile = ?", params[:master_profile_id]) if params[:master_profile_id].present?
    @matrix_users = @matrix_users.where("matrix_users.sub_distribuidor = ?", params[:sub_distribuidor_id]) if params[:sub_distribuidor_id].present?
    @matrix_users = @matrix_users.where("matrix_users.sub_agente = ?", params[:sub_agente_id]) if params[:sub_agente_id].present?

    options = {page: params[:page] || 1, per_page: 10}
    @matrix_users = @matrix_users.paginate(options)
  end

  # GET /matrix_users/1
  # GET /matrix_users/1.json
  def show
  end

  # GET /matrix_users/new
  def new
    @matrix_user = MatrixUser.new
  end

  # GET /matrix_users/1/edit
  def edit
  end

  # POST /matrix_users
  # POST /matrix_users.json
  def create
    @matrix_user = MatrixUser.new(matrix_user_params)
    @matrix_user.responsavel = usuario_logado

    respond_to do |format|
      if @matrix_user.save
        format.html { redirect_to @matrix_user, notice: 'Matrix user foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @matrix_user }
      else
        format.html { render :new }
        format.json { render json: @matrix_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matrix_users/1
  # PATCH/PUT /matrix_users/1.json
  def update
    respond_to do |format|
      if @matrix_user.update(matrix_user_params)
        format.html { redirect_to @matrix_user, notice: 'Matrix user foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @matrix_user }
      else
        format.html { render :edit }
        format.json { render json: @matrix_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matrix_users/1
  # DELETE /matrix_users/1.json
  def destroy
    @matrix_user.destroy
    respond_to do |format|
      format.html { redirect_to matrix_users_url, notice: 'Matrix user foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matrix_user
      @matrix_user = MatrixUser.find(params[:id])
      @matrix_user.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matrix_user_params
      params.require(:matrix_user).permit(:usuario_id, :master_profile, :sub_distribuidor, :sub_agente, :filial, :pdv)
    end
end
