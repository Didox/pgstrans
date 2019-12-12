class MoedasController < ApplicationController
  before_action :set_moeda, only: [:show, :edit, :update, :destroy]

  # GET /moedas
  # GET /moedas.json
  def index
    @moedas = Moeda.all.order(nome: :asc)
  end

  # GET /moedas/1
  # GET /moedas/1.json
  def show
  end

  # GET /moedas/new
  def new
    @moeda = Moeda.new
  end

  # GET /moedas/1/edit
  def edit
  end

  # POST /moedas
  # POST /moedas.json
  def create
    @moeda = Moeda.new(moeda_params)

    respond_to do |format|
      if @moeda.save
        format.html { redirect_to @moeda, notice: 'Moeda foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @moeda }
      else
        format.html { render :new }
        format.json { render json: @moeda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moedas/1
  # PATCH/PUT /moedas/1.json
  def update
    respond_to do |format|
      if @moeda.update(moeda_params)
        format.html { redirect_to @moeda, notice: 'Moeda foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @moeda }
      else
        format.html { render :edit }
        format.json { render json: @moeda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moedas/1
  # DELETE /moedas/1.json
  def destroy
    @moeda.destroy
    respond_to do |format|
      format.html { redirect_to moedas_url, notice: 'Moeda foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moeda
      @moeda = Moeda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moeda_params
      params.require(:moeda).permit(:nome, :codigo_iso, :simbolo, :country_id, :name_pt)
    end
end
