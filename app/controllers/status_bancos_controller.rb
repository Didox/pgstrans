class StatusBancosController < ApplicationController
  before_action :set_status_banco, only: [:show, :edit, :update, :destroy]

  # GET /status_bancos
  # GET /status_bancos.json
  def index
    @status_bancos = StatusBanco.com_acesso(usuario_logado)  

    @status_bancos = @status_bancos.where("nome ilike '%#{params[:nome]}%'") if params[:nome].present?

    options = {page: params[:page] || 1, per_page: 10}
    @status_bancos = @status_bancos.paginate(options)

  end

  # GET /status_bancos/1
  # GET /status_bancos/1.json
  def show
  end

  # GET /status_bancos/new
  def new
    @status_banco = StatusBanco.new
  end

  # GET /status_bancos/1/edit
  def edit
  end

  # POST /status_bancos
  # POST /status_bancos.json
  def create
    @status_banco = StatusBanco.new(status_banco_params)
    @status_banco.responsavel = usuario_logado

    respond_to do |format|
      if @status_banco.save
        format.html { redirect_to @status_banco, notice: 'Status banco was successfully created.' }
        format.json { render :show, status: :created, location: @status_banco }
      else
        format.html { render :new }
        format.json { render json: @status_banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_bancos/1
  # PATCH/PUT /status_bancos/1.json
  def update
    respond_to do |format|
      if @status_banco.update(status_banco_params)
        format.html { redirect_to @status_banco, notice: 'Status banco was successfully updated.' }
        format.json { render :show, status: :ok, location: @status_banco }
      else
        format.html { render :edit }
        format.json { render json: @status_banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_bancos/1
  # DELETE /status_bancos/1.json
  def destroy
    @status_banco.destroy
    respond_to do |format|
      format.html { redirect_to status_bancos_url, notice: 'Status banco was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_banco
      @status_banco = StatusBanco.find(params[:id])
      @status_banco.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_banco_params
      params.require(:status_banco).permit(:nome)
    end
end
