class ErroAmigavelsController < ApplicationController
  before_action :set_erro_amigavel, only: [:show, :edit, :update, :destroy]

  # GET /erro_amigavels
  # GET /erro_amigavels.json
  def index
    @erro_amigavels = ErroAmigavel.all
  end

  # GET /erro_amigavels/1
  # GET /erro_amigavels/1.json
  def show
  end

  # GET /erro_amigavels/new
  def new
    @erro_amigavel = ErroAmigavel.new
  end

  # GET /erro_amigavels/1/edit
  def edit
  end

  # POST /erro_amigavels
  # POST /erro_amigavels.json
  def create
    @erro_amigavel = ErroAmigavel.new(erro_amigavel_params)

    respond_to do |format|
      if @erro_amigavel.save
        format.html { redirect_to @erro_amigavel, notice: 'Erro amigável cadastrado com sucesso.' }
        format.json { render :show, status: :created, location: @erro_amigavel }
      else
        format.html { render :new }
        format.json { render json: @erro_amigavel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /erro_amigavels/1
  # PATCH/PUT /erro_amigavels/1.json
  def update
    respond_to do |format|
      if @erro_amigavel.update(erro_amigavel_params)
        format.html { redirect_to @erro_amigavel, notice: 'Erro amigável alterado com sucesso.' }
        format.json { render :show, status: :ok, location: @erro_amigavel }
      else
        format.html { render :edit }
        format.json { render json: @erro_amigavel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /erro_amigavels/1
  # DELETE /erro_amigavels/1.json
  def destroy
    @erro_amigavel.destroy
    respond_to do |format|
      format.html { redirect_to erro_amigavels_url, notice: 'Erro amigável apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_erro_amigavel
      @erro_amigavel = ErroAmigavel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def erro_amigavel_params
      params.require(:erro_amigavel).permit(:de, :para)
    end
end
