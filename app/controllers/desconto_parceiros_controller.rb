class DescontoParceirosController < ApplicationController
  before_action :set_desconto_parceiro, only: [:show, :edit, :update, :destroy]
  before_action :set_partner

  # GET /desconto_parceiros
  # GET /desconto_parceiros.json
  def index
    @desconto_parceiros = DescontoParceiro.where(partner_id: @partner.id)
  end

  # GET /desconto_parceiros/1
  # GET /desconto_parceiros/1.json
  def show
  end

  # GET /desconto_parceiros/new
  def new
    @desconto_parceiro = DescontoParceiro.new
    @desconto_parceiro.partner_id = @partner.id
  end

  # GET /desconto_parceiros/1/edit
  def edit
  end

  # POST /desconto_parceiros
  # POST /desconto_parceiros.json
  def create
    @desconto_parceiro = DescontoParceiro.new(desconto_parceiro_params)
    @desconto_parceiro.partner_id = @partner.id

    respond_to do |format|
      if @desconto_parceiro.save
        format.html { redirect_to partner_desconto_parceiros_path(@partner), notice: 'Desconto parceiro foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @desconto_parceiro }
      else
        format.html { render :new }
        format.json { render json: @desconto_parceiro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /desconto_parceiros/1
  # PATCH/PUT /desconto_parceiros/1.json
  def update
    respond_to do |format|
      if @desconto_parceiro.update(desconto_parceiro_params)
        format.html { redirect_to partner_desconto_parceiros_path(@partner), notice: 'Desconto parceiro foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @desconto_parceiro }
      else
        format.html { render :edit }
        format.json { render json: @desconto_parceiro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /desconto_parceiros/1
  # DELETE /desconto_parceiros/1.json
  def destroy
    @desconto_parceiro.destroy
    respond_to do |format|
      format.html { redirect_to partner_desconto_parceiros_path(@partner), notice: 'Desconto parceiro foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def set_partner
      @partner = Partner.find(params[:partner_id])
    end

    def set_desconto_parceiro
      @desconto_parceiro = DescontoParceiro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def desconto_parceiro_params
      params.require(:desconto_parceiro).permit(:porcentagem, :partner_id)
    end
end
