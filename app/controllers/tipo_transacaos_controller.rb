class TipoTransacaosController < ApplicationController
  before_action :set_tipo_transacao, only: [:show, :edit, :update, :destroy]

  # GET /tipo_transacaos
  # GET /tipo_transacaos.json
  def index
    @tipo_transacaos = TipoTransacao.all
  end

  # GET /tipo_transacaos/1
  # GET /tipo_transacaos/1.json
  def show
  end

  # GET /tipo_transacaos/new
  def new
    @tipo_transacao = TipoTransacao.new
  end

  # GET /tipo_transacaos/1/edit
  def edit
  end

  # POST /tipo_transacaos
  # POST /tipo_transacaos.json
  def create
    @tipo_transacao = TipoTransacao.new(tipo_transacao_params)

    respond_to do |format|
      if @tipo_transacao.save
        format.html { redirect_to @tipo_transacao, notice: 'Tipo transacao was successfully created.' }
        format.json { render :show, status: :created, location: @tipo_transacao }
      else
        format.html { render :new }
        format.json { render json: @tipo_transacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_transacaos/1
  # PATCH/PUT /tipo_transacaos/1.json
  def update
    respond_to do |format|
      if @tipo_transacao.update(tipo_transacao_params)
        format.html { redirect_to @tipo_transacao, notice: 'Tipo transacao was successfully updated.' }
        format.json { render :show, status: :ok, location: @tipo_transacao }
      else
        format.html { render :edit }
        format.json { render json: @tipo_transacao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_transacaos/1
  # DELETE /tipo_transacaos/1.json
  def destroy
    @tipo_transacao.destroy
    respond_to do |format|
      format.html { redirect_to tipo_transacaos_url, notice: 'Tipo transacao was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_transacao
      @tipo_transacao = TipoTransacao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_transacao_params
      params.require(:tipo_transacao).permit(:nome)
    end
end