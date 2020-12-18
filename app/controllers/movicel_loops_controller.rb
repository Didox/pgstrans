class MovicelLoopsController < ApplicationController
  before_action :set_movicel_loop, only: [:show, :edit, :update, :destroy, :processar]

  # GET /movicel_loops
  # GET /movicel_loops.json
  def index
    @movicel_loops = MovicelLoop.all
  end

  # GET /movicel_loops/1
  # GET /movicel_loops/1.json
  def show
  end

  # GET /movicel_loops/new
  def new
    @movicel_loop = MovicelLoop.new
  end

  # GET /movicel_loops/1/edit
  def edit
  end

  def processar
    @movicel_loop.processar = true
    @movicel_loop.save
    flash[:success] = "Os dados estão sendo processados, logo será finalizado"
    redirect_to "/movicel_loops/#{@movicel_loop.id}"
  end

  # POST /movicel_loops
  # POST /movicel_loops.json
  def create
    @movicel_loop = MovicelLoop.new(movicel_loop_params)

    respond_to do |format|
      if @movicel_loop.save
        format.html { redirect_to @movicel_loop, notice: 'Movicel loop foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @movicel_loop }
      else
        format.html { render :new }
        format.json { render json: @movicel_loop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movicel_loops/1
  # PATCH/PUT /movicel_loops/1.json
  def update
    respond_to do |format|
      if @movicel_loop.update(movicel_loop_params)
        format.html { redirect_to @movicel_loop, notice: 'Movicel loop foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @movicel_loop }
      else
        format.html { render :edit }
        format.json { render json: @movicel_loop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movicel_loops/1
  # DELETE /movicel_loops/1.json
  def destroy
    @movicel_loop.destroy
    respond_to do |format|
      format.html { redirect_to movicel_loops_url, notice: 'Movicel loop foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movicel_loop
      @movicel_loop = MovicelLoop.find(params[:id] || params[:movicel_loop_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movicel_loop_params
      params.require(:movicel_loop).permit(:usuario, :token, :uri, :ambiente, :agente, :terminal, :valor, :repeticao, :nropedidoinicio, :nropedido, :request, :response, :processar_loop)
    end
end
