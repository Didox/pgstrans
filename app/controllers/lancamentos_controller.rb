class LancamentosController < ApplicationController
  before_action :set_lancamento, only: [:show, :edit, :update, :destroy]

  # GET /lancamentos
  # GET /lancamentos.json
  def index
    @lancamentos = Lancamento.all.order(nome: :asc)

    options = {page: params[:page] || 1, per_page: 10}
    @lancamentos = @lancamentos.paginate(options)
  end

  # GET /lancamentos/1
  # GET /lancamentos/1.json
  def show
  end

  # GET /lancamentos/new
  def new
    @lancamento = Lancamento.new
  end

  # GET /lancamentos/1/edit
  def edit
  end

  # POST /lancamentos
  # POST /lancamentos.json
  def create
    @lancamento = Lancamento.new(lancamento_params)

    if @lancamento.nome != "Compra de crédito ou recarga"
      flash[:error] = "Este status é de uso interno - não pode ser alterado"
      redirect_to "/lancamentos"
      return
    end

    respond_to do |format|
      if @lancamento.save
        format.html { redirect_to @lancamento, notice: 'Lancamento foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @lancamento }
      else
        format.html { render :new }
        format.json { render json: @lancamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lancamentos/1
  # PATCH/PUT /lancamentos/1.json
  def update
    if @lancamento.nome != "Compra de crédito ou recarga"
      flash[:error] = "Este status é de uso interno - não pode ser alterado"
      redirect_to "/lancamentos"
      return
    end

    respond_to do |format|
      if @lancamento.update(lancamento_params)
        format.html { redirect_to @lancamento, notice: 'Lancamento foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @lancamento }
      else
        format.html { render :edit }
        format.json { render json: @lancamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lancamentos/1
  # DELETE /lancamentos/1.json
  def destroy
    if @lancamento.nome != "Compra de crédito ou recarga"
      flash[:error] = "Este status é de uso interno não - pode ser alterado"
      redirect_to "/lancamentos"
      return
    end
    
    @lancamento.destroy
    respond_to do |format|
      format.html { redirect_to lancamentos_url, notice: 'Lancamento foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lancamento
      @lancamento = Lancamento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lancamento_params
      params.require(:lancamento).permit(:nome)
    end
end
