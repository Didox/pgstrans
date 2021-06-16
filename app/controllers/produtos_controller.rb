class ProdutosController < ApplicationController
  before_action :set_produto, only: [:show, :edit, :update, :destroy]

  # GET /produtos
  # GET /produtos.json
  def index
    @produtos = Produto.all.order(partner_id: :asc, description: :asc)

    @produtos = @produtos.where(partner_id: params[:partner_id]) if params[:partner_id].present?
    @produtos = @produtos.where("id = ?", params[:id]) if params[:id].present?
    @produtos = @produtos.where("produto_id_parceiro = ?", params[:produto_id_parceiro]) if params[:produto_id_parceiro].present?
    @produtos = @produtos.where("description ilike '%#{params[:nome]}%'") if params[:nome].present?
    @produtos = @produtos.where("nome_comercial ilike '%#{params[:nome_comercial]}%'") if params[:nome_comercial].present?
    @produtos = @produtos.where("partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
    @produtos = @produtos.where("moeda_id = ?", params[:moeda_id]) if params[:moeda_id].present?
    @produtos = @produtos.where("status_produto_id = ?", params[:status_produto_id]) if params[:status_produto_id].present?

    @produtos = @produtos.where("created_at >= ?", SqlDate.sql_parse(params[:created_at].to_datetime.beginning_of_day)) if params[:created_at].present?
    @produtos = @produtos.where("created_at <= ?", SqlDate.sql_parse(params[:created_at_fim].to_datetime.end_of_day)) if params[:created_at_fim].present?

    @produtos = @produtos.where("updated_at >= ?", SqlDate.sql_parse(params[:updated_at].to_datetime.beginning_of_day)) if params[:updated_at].present?
    @produtos = @produtos.where("updated_at <= ?", SqlDate.sql_parse(params[:updated_at_fim].to_datetime.end_of_day)) if params[:updated_at_fim].present?

    @produtos = @produtos.where("data_vigencia >= ?", SqlDate.sql_parse(params[:data_vigencia].to_datetime.beginning_of_day)) if params[:data_vigencia].present?
    @produtos = @produtos.where("data_vigencia < ?", SqlDate.sql_parse(params[:data_vigencia].to_datetime.end_of_day)) if params[:data_vigencia].present?

    @produtos_total = @produtos.count
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
    
    def set_produto
      @produto = Produto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def produto_params
      params.require(:produto).permit(:partner_id, :description, :status_produto_id, :valor_compra_telemovel, 
        :valor_compra_site, :valor_compra_pos, :valor_compra_tef, 
        :mensagem_cupom_venda, :moeda_id, :produto_id_parceiro, 
        :valor_unitario, :tipo, :subtipo, :data_vigencia, :nome_comercial)
    end
end
