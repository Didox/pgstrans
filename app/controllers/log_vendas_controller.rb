class LogVendasController < ApplicationController
  before_action :set_log_venda, only: [:show, :edit, :update, :destroy]

  # GET /log_vendas
  # GET /log_vendas.json
  def index
    @log_vendas = LogVenda.all.order(updated_at: :desc, titulo: :desc)

    if params[:nome].present?
      @log_vendas = @log_vendas.joins(:usuario)
      @log_vendas = @log_vendas.where("usuarios.nome ilike '%#{params[:nome]}%'")
    end
    
    @log_vendas = @log_vendas.where("titulo ilike '%#{params[:titulo]}%'") if params[:titulo].present?
    @log_vendas = @log_vendas.where("log ilike '%#{params[:log]}%'") if params[:log].present?

    @log_vendas_total = @log_vendas.count

    options = {page: params[:page] || 1, per_page: 10}
    @log_vendas = @log_vendas.paginate(options)
  end

  # GET /log_vendas/1
  # GET /log_vendas/1.json
  def show
    redirect_to "/log_vendas"
  end

  # GET /log_vendas/new
  def new
    redirect_to "/log_vendas"
    return
    @log_venda = LogVenda.new
  end

  # GET /log_vendas/1/edit
  def edit
    redirect_to "/log_vendas"
    return
  end

  # POST /log_vendas
  # POST /log_vendas.json
  def create
    redirect_to "/log_vendas"
    return
    @log_venda = LogVenda.new(log_venda_params)

    respond_to do |format|
      if @log_venda.save
        format.html { redirect_to @log_venda, notice: 'Log venda foi criado com sucesso.' }
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
    redirect_to "/log_vendas"
    return
    respond_to do |format|
      if @log_venda.update(log_venda_params)
        format.html { redirect_to @log_venda, notice: 'Log venda foi atualizado com sucesso.' }
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
    redirect_to "/log_vendas"
    return
    @log_venda.destroy
    respond_to do |format|
      format.html { redirect_to log_vendas_url, notice: 'Log venda foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_log_venda
      @log_venda = LogVenda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_venda_params
      params.require(:log_venda).permit(:titulo, :log)
    end
end
