class StatusClientesController < ApplicationController
  before_action :set_status_cliente, only: [:show, :edit, :update, :destroy]

  # GET /status_clientes
  # GET /status_clientes.json
  def index
    @status_clientes = StatusCliente.all.order(nome: :asc)
  end

  # GET /status_clientes/1
  # GET /status_clientes/1.json
  def show
  end

  # GET /status_clientes/new
  def new
    @status_cliente = StatusCliente.new
  end

  # GET /status_clientes/1/edit
  def edit
  end

  # POST /status_clientes
  # POST /status_clientes.json
  def create
    @status_cliente = StatusCliente.new(status_cliente_params)

    respond_to do |format|
      if @status_cliente.save
        format.html { redirect_to @status_cliente, notice: 'Status cliente was successfully created.' }
        format.json { render :show, status: :created, location: @status_cliente }
      else
        format.html { render :new }
        format.json { render json: @status_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_clientes/1
  # PATCH/PUT /status_clientes/1.json
  def update
    respond_to do |format|
      if @status_cliente.update(status_cliente_params)
        format.html { redirect_to @status_cliente, notice: 'Status cliente was successfully updated.' }
        format.json { render :show, status: :ok, location: @status_cliente }
      else
        format.html { render :edit }
        format.json { render json: @status_cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_clientes/1
  # DELETE /status_clientes/1.json
  def destroy
    @status_cliente.destroy
    respond_to do |format|
      format.html { redirect_to status_clientes_url, notice: 'Status cliente was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_cliente
      @status_cliente = StatusCliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_cliente_params
      params.require(:status_cliente).permit(:nome)
    end
end
