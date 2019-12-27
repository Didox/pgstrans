class StatusParceirosController < ApplicationController
  before_action :set_status_parceiro, only: [:show, :edit, :update, :destroy]

  # GET /status_parceiros
  # GET /status_parceiros.json
  def index
    @status_parceiros = StatusParceiro.all
  end

  # GET /status_parceiros/1
  # GET /status_parceiros/1.json
  def show
  end

  # GET /status_parceiros/new
  def new
    @status_parceiro = StatusParceiro.new
  end

  # GET /status_parceiros/1/edit
  def edit
  end

  # POST /status_parceiros
  # POST /status_parceiros.json
  def create
    @status_parceiro = StatusParceiro.new(status_parceiro_params)

    respond_to do |format|
      if @status_parceiro.save
        format.html { redirect_to @status_parceiro, notice: 'Status parceiro was successfully created.' }
        format.json { render :show, status: :created, location: @status_parceiro }
      else
        format.html { render :new }
        format.json { render json: @status_parceiro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_parceiros/1
  # PATCH/PUT /status_parceiros/1.json
  def update
    respond_to do |format|
      if @status_parceiro.update(status_parceiro_params)
        format.html { redirect_to @status_parceiro, notice: 'Status parceiro was successfully updated.' }
        format.json { render :show, status: :ok, location: @status_parceiro }
      else
        format.html { render :edit }
        format.json { render json: @status_parceiro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_parceiros/1
  # DELETE /status_parceiros/1.json
  def destroy
    @status_parceiro.destroy
    respond_to do |format|
      format.html { redirect_to status_parceiros_url, notice: 'Status parceiro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_parceiro
      @status_parceiro = StatusParceiro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_parceiro_params
      params.require(:status_parceiro).permit(:nome)
    end
end