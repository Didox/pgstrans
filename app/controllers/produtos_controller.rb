class ProdutosController < ApplicationController
  before_action :set_produto, only: [:show, :edit, :update, :destroy]

  # GET /produtos
  # GET /produtos.json
  def index
    @produtos = Produto.com_acesso(usuario_logado).order(description: :asc)  

    @produtos = @produtos.where(partner_id: params[:partner_id]) if params[:partner_id].present?
    @produtos = @produtos.where("description ilike '%#{params[:nome]}%'") if params[:nome].present?
    @produtos = @produtos.where("partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
    @produtos = @produtos.where("moeda_id = ?", params[:moeda_id]) if params[:moeda_id].present?
    @produtos = @produtos.where("status_produto_id = ?", params[:status_produto_id]) if params[:status_produto_id].present?
    @produtos = @produtos.where("margem_telemovel = ?", params[:margem_telemovel].to_f) if params[:margem_telemovel].present?
    @produtos = @produtos.where("margem_site = ?", params[:margem_site].to_f) if params[:margem_site].present?
  
    options = {page: params[:page] || 1, per_page: 10}
    @produtos = @produtos.paginate(options)

  end

  # GET /produtos/1
  # GET /produtos/1.json
  def show
  end

  # GET /produtos/new
  def new
    @produto = Produto.new
  end

  # GET /produtos/1/edit
  def edit
  end

  # POST /produtos
  # POST /produtos.json
  def create
    @produto = Produto.new(produto_params)
    @produto.responsavel = usuario_logado

    respond_to do |format|
      if @produto.save
        format.html { redirect_to @produto, notice: 'Produto foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @produto }
      else
        format.html { render :new }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /produtos/1
  # PATCH/PUT /produtos/1.json
  def update
    respond_to do |format|
      if @produto.update(produto_params)
        format.html { redirect_to @produto, notice: 'Produto foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @produto }
      else
        format.html { render :edit }
        format.json { render json: @produto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos/1
  # DELETE /produtos/1.json
  def destroy
    @produto.destroy
    respond_to do |format|
      format.html { redirect_to produtos_url, notice: 'Produto foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produto
      @produto = Produto.find(params[:id])
      @produto.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def produto_params
      params.require(:produto).permit(:description, :partner_id, :status_produto_id, :valor_compra_telemovel, :valor_compra_site, :valor_compra_pos, :valor_compra_tef, :valor_minimo_venda_telemovel, :valor_minimo_venda_site, :valor_minimo_venda_pos, :valor_minimo_venda_tef, :margem_telemovel, :margem_site, :margem_pos, :margem_tef, :mensagem_cupom_venda, :moeda_id, :produto_id_parceiro, :valor_unitario, :tipo, :subtipo)
    end
end
