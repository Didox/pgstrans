class MovimentacaoContaController < ApplicationController
  before_action :set_movimentacao_contum, only: [:show, :edit, :update, :destroy]

  # GET /movimentacao_conta
  # GET /movimentacao_conta.json
  def index
    @movimentacao_conta = MovimentacaoContum.all
  end

  # GET /movimentacao_conta/1
  # GET /movimentacao_conta/1.json
  def show
  end

  # GET /movimentacao_conta/new
  def new
    @movimentacao_contum = MovimentacaoContum.new
  end

  # GET /movimentacao_conta/1/edit
  def edit
  end

  # POST /movimentacao_conta
  # POST /movimentacao_conta.json
  def create
    @movimentacao_contum = MovimentacaoContum.new(movimentacao_contum_params)

    respond_to do |format|
      if @movimentacao_contum.save
        format.html { redirect_to @movimentacao_contum, notice: 'Movimentacao contum was successfully created.' }
        format.json { render :show, status: :created, location: @movimentacao_contum }
      else
        format.html { render :new }
        format.json { render json: @movimentacao_contum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movimentacao_conta/1
  # PATCH/PUT /movimentacao_conta/1.json
  def update
    respond_to do |format|
      if @movimentacao_contum.update(movimentacao_contum_params)
        format.html { redirect_to @movimentacao_contum, notice: 'Movimentacao contum was successfully updated.' }
        format.json { render :show, status: :ok, location: @movimentacao_contum }
      else
        format.html { render :edit }
        format.json { render json: @movimentacao_contum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movimentacao_conta/1
  # DELETE /movimentacao_conta/1.json
  def destroy
    @movimentacao_contum.destroy
    respond_to do |format|
      format.html { redirect_to movimentacao_conta_url, notice: 'Movimentacao contum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimentacao_contum
      @movimentacao_contum = MovimentacaoContum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movimentacao_contum_params
      params.require(:movimentacao_contum).permit(:nome)
    end
end
