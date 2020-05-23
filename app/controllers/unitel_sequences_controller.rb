class UnitelSequencesController < ApplicationController
  before_action :set_unitel_sequence, only: [:show, :edit, :update, :destroy]

  # GET /unitel_sequences
  # GET /unitel_sequences.json
  def index
    @unitel_sequences = UnitelSequence.com_acesso(usuario_logado).order(id: :desc)  

    options = {page: params[:page] || 1, per_page: 10}
    @unitel_sequences = @unitel_sequences.paginate(options)
  end

  # GET /unitel_sequences/1
  # GET /unitel_sequences/1.json
  def show
  end

  # GET /unitel_sequences/new
  def new
    @unitel_sequence = UnitelSequence.new
  end

  # GET /unitel_sequences/1/edit
  def edit
  end

  # POST /unitel_sequences
  # POST /unitel_sequences.json
  def create
    @unitel_sequence = UnitelSequence.new(unitel_sequence_params)
    @unitel_sequence.responsavel = usuario_logado

    respond_to do |format|
      if @unitel_sequence.save
        format.html { redirect_to @unitel_sequence, notice: 'Código de sequência Unitel foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @unitel_sequence }
      else
        format.html { render :new }
        format.json { render json: @unitel_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unitel_sequences/1
  # PATCH/PUT /unitel_sequences/1.json
  def update
    respond_to do |format|
      if @unitel_sequence.update(unitel_sequence_params)
        format.html { redirect_to @unitel_sequence, notice: 'Código de sequência Unitel foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @unitel_sequence }
      else
        format.html { render :edit }
        format.json { render json: @unitel_sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unitel_sequences/1
  # DELETE /unitel_sequences/1.json
  def destroy
    @unitel_sequence.destroy
    respond_to do |format|
      format.html { redirect_to unitel_sequences_url, notice: 'Código de sequência Unitel foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unitel_sequence
      @unitel_sequence = UnitelSequence.find(params[:id])
      @unitel_sequence.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unitel_sequence_params
      params.require(:unitel_sequence).permit(:sequence_id, :venda_id)
    end
end
