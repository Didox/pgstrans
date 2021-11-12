class SubDistribuidorsController < ApplicationController
  before_action :set_sub_distribuidor, only: [:show, :edit, :update, :destroy]

  # GET /sub_distribuidors
  # GET /sub_distribuidors.json
  def index
    @sub_distribuidors = SubDistribuidor.com_acesso(usuario_logado).order(nome: :asc)

    @sub_distribuidors = @sub_distribuidors.where("nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @sub_distribuidors = @sub_distribuidors.where("morada ilike '%#{params[:morada].remove_injection}%'") if params[:morada].present?
    @sub_distribuidors = @sub_distribuidors.where("municipio_id = ?", params[:municipio_id]) if params[:municipio_id].present?
    @sub_distribuidors = @sub_distribuidors.where("provincia_id = ?", params[:provincia_id]) if params[:provincia_id].present?

    options = {page: params[:page] || 1, per_page: 10}
    @sub_distribuidors = @sub_distribuidors.paginate(options)
  end

  # GET /sub_distribuidors/1
  # GET /sub_distribuidors/1.json
  def show
  end

  # GET /sub_distribuidors/new
  def new
    @sub_distribuidor = SubDistribuidor.new
  end

  # GET /sub_distribuidors/1/edit
  def edit
  end

  # POST /sub_distribuidors
  # POST /sub_distribuidors.json
  def create
    @sub_distribuidor = SubDistribuidor.new(sub_distribuidor_params)
    @sub_distribuidor.responsavel = usuario_logado

    respond_to do |format|
      if @sub_distribuidor.save
        salvar_remuneracao_desconto
        format.html { redirect_to @sub_distribuidor, notice: 'Subdistribuidor foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @sub_distribuidor }
      else
        format.html { render :new }
        format.json { render json: @sub_distribuidor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_distribuidors/1
  # PATCH/PUT /sub_distribuidors/1.json
  def update
    respond_to do |format|
      if @sub_distribuidor.update(sub_distribuidor_params)
        salvar_remuneracao_desconto
        format.html { redirect_to @sub_distribuidor, notice: 'Subdistribuidor foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @sub_distribuidor }
      else
        format.html { render :edit }
        format.json { render json: @sub_distribuidor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_distribuidors/1
  # DELETE /sub_distribuidors/1.json
  def destroy
    @sub_distribuidor.destroy
    respond_to do |format|
      format.html { redirect_to sub_distribuidors_url, notice: 'Subdistribuidor foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

    def salvar_remuneracao_desconto
      DistribuidorDesconto.where(sub_distribuidor_id: @sub_distribuidor.id).destroy_all
      if params[:partner_descontos].present?
        params[:partner_descontos].each do |partner_desconto|
          DistribuidorDesconto.create(
            partner_id: partner_desconto["id"],
            sub_distribuidor_id: @sub_distribuidor.id,
            desconto_parceiro_id: params["parceiro_desconto_id_partner_id_#{partner_desconto["id"]}"]
          )
        end
      end
    end
    
    def set_sub_distribuidor
      @sub_distribuidor = SubDistribuidor.find(params[:id])
      @sub_distribuidor.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_distribuidor_params
      params.require(:sub_distribuidor).permit(:nome, :bi, :telefone, :morada, :municipio_id, :provincia_id, :interface_operacao, :site, :ramo_negociacao)
    end
end
