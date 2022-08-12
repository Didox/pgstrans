class ModalInformativosController < ApplicationController
  before_action :set_modal_informativo, only: %i[ show edit update destroy ]

  # GET /modal_informativos or /modal_informativos.json
  def index
    @modal_informativos = ModalInformativo.all
  end

  # GET /modal_informativos/1 or /modal_informativos/1.json
  def show
  end

  # GET /modal_informativos/new
  def new
    @modal_informativo = ModalInformativo.new
  end

  # GET /modal_informativos/1/edit
  def edit
  end

  # POST /modal_informativos or /modal_informativos.json
  def create
    @modal_informativo = ModalInformativo.new(modal_informativo_params)

    respond_to do |format|
      if @modal_informativo.save
        format.html { redirect_to modal_informativo_url(@modal_informativo), notice: "Mensagem para o Modal Informativo criada com sucesso." }
        format.json { render :show, status: :created, location: @modal_informativo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @modal_informativo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modal_informativos/1 or /modal_informativos/1.json
  def update
    respond_to do |format|
      if @modal_informativo.update(modal_informativo_params)
        format.html { redirect_to modal_informativo_url(@modal_informativo), notice: "Mensagem para o Modal Informativo alterada com sucesso." }
        format.json { render :show, status: :ok, location: @modal_informativo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @modal_informativo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modal_informativos/1 or /modal_informativos/1.json
  def destroy
    @modal_informativo.destroy

    respond_to do |format|
      format.html { redirect_to modal_informativos_url, notice: "Mensagem para o Modal Informativo apagada com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modal_informativo
      @modal_informativo = ModalInformativo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def modal_informativo_params
      params.require(:modal_informativo).permit(:titulo, :mensagem, :ativa)
    end
end
