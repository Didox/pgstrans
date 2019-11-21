class MatrixUsersController < ApplicationController
  before_action :set_matrix_user, only: [:show, :edit, :update, :destroy]

  # GET /matrix_users
  # GET /matrix_users.json
  def index
    @matrix_users = MatrixUser.all
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

    respond_to do |format|
      if @matrix_user.save
        format.html { redirect_to @matrix_user, notice: 'Matrix user was successfully created.' }
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
        format.html { redirect_to @matrix_user, notice: 'Matrix user was successfully updated.' }
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
      format.html { redirect_to matrix_users_url, notice: 'Matrix user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matrix_user
      @matrix_user = MatrixUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matrix_user_params
      params.require(:matrix_user).permit(:usuario_id, :master_profile, :sub_distribuidor, :sub_agente, :filial, :pdv)
    end
end
