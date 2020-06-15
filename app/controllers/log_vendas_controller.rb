class LogVendasController < ApplicationController
  before_action :set_log_venda, only: [:show, :edit, :update, :destroy]

  # GET /log_vendas
  # GET /log_vendas.json
  def index
    @log_vendas = LogVenda.all
  end

  # GET /log_vendas/1
  # GET /log_vendas/1.json
  def show
  end

  # GET /log_vendas/new
  def new
    @log_venda = LogVenda.new
  end

  # GET /log_vendas/1/edit
  def edit
  end

  # POST /log_vendas
  # POST /log_vendas.json
  def create
    @log_venda = LogVenda.new(log_venda_params)

    respond_to do |format|
      if @log_venda.save
        format.html { redirect_to @log_venda, notice: 'Log venda was successfully created.' }
        format.json { render :show, status: :created, location: @log_venda }
      else
        format.html { render :new }
        format.json { render json: @log_venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /log_vendas/1
  # PATCH/PUT /log_vendas/1.json
  def update
    respond_to do |format|
      if @log_venda.update(log_venda_params)
        format.html { redirect_to @log_venda, notice: 'Log venda was successfully updated.' }
        format.json { render :show, status: :ok, location: @log_venda }
      else
        format.html { render :edit }
        format.json { render json: @log_venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /log_vendas/1
  # DELETE /log_vendas/1.json
  def destroy
    @log_venda.destroy
    respond_to do |format|
      format.html { redirect_to log_vendas_url, notice: 'Log venda was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log_venda
      @log_venda = LogVenda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_venda_params
      params.require(:log_venda).permit(:titulo, :log)
    end
end
