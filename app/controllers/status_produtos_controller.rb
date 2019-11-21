class StatusProdutosController < ApplicationController
  before_action :set_status_produto, only: [:show, :edit, :update, :destroy]

  # GET /status_produtos
  # GET /status_produtos.json
  def index
    @status_produtos = StatusProduto.all
  end

  # GET /status_produtos/1
  # GET /status_produtos/1.json
  def show
  end

  # GET /status_produtos/new
  def new
    @status_produto = StatusProduto.new
  end

  # GET /status_produtos/1/edit
  def edit
  end

  # POST /status_produtos
  # POST /status_produtos.json
  def create
    @status_produto = StatusProduto.new(status_produto_params)

    respond_to do |format|
      if @status_produto.save
        format.html { redirect_to @status_produto, notice: 'Status produto foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @status_produto }
      else
        format.html { render :new }
        format.json { render json: @status_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_produtos/1
  # PATCH/PUT /status_produtos/1.json
  def update
    respond_to do |format|
      if @status_produto.update(status_produto_params)
        format.html { redirect_to @status_produto, notice: 'Status produto foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @status_produto }
      else
        format.html { render :edit }
        format.json { render json: @status_produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_produtos/1
  # DELETE /status_produtos/1.json
  def destroy
    @status_produto.destroy
    respond_to do |format|
      format.html { redirect_to status_produtos_url, notice: 'Status produto foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_produto
      @status_produto = StatusProduto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_produto_params
      params.require(:status_produto).permit(:nome)
    end
end
