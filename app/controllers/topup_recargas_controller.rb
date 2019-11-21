class TopupRecargasController < ApplicationController
  before_action :set_topup_recarga, only: [:show, :edit, :update, :destroy]

  # GET /topup_recargas
  # GET /topup_recargas.json
  def index
    @topup_recargas = TopupRecarga.all
  end

  # GET /topup_recargas/1
  # GET /topup_recargas/1.json
  def show
  end

  # GET /topup_recargas/new
  def new
    @topup_recarga = TopupRecarga.new
  end

  # GET /topup_recargas/1/edit
  def edit
  end

  # POST /topup_recargas
  # POST /topup_recargas.json
  def create
    @topup_recarga = TopupRecarga.new(topup_recarga_params)

    respond_to do |format|
      if @topup_recarga.save
        format.html { redirect_to @topup_recarga, notice: 'Topup recarga foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @topup_recarga }
      else
        format.html { render :new }
        format.json { render json: @topup_recarga.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topup_recargas/1
  # PATCH/PUT /topup_recargas/1.json
  def update
    respond_to do |format|
      if @topup_recarga.update(topup_recarga_params)
        format.html { redirect_to @topup_recarga, notice: 'Topup recarga foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @topup_recarga }
      else
        format.html { render :edit }
        format.json { render json: @topup_recarga.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topup_recargas/1
  # DELETE /topup_recargas/1.json
  def destroy
    @topup_recarga.destroy
    respond_to do |format|
      format.html { redirect_to topup_recargas_url, notice: 'Topup recarga foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topup_recarga
      @topup_recarga = TopupRecarga.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topup_recarga_params
      params.require(:topup_recarga).permit(:validation_id, :header_element, :topup_req_header, :request_id, :header_timestamp, :header_source_system, :credentials_element, :credentials_user, :credentials_password, :attributes_list, :attribute_element, :attribute_name, :attribute_value, :body_element, :body_req_element, :body_input_message, :body_topup_req_body_type, :body_topup_req_body_amount, :body_topup_req_body_msisdn, :od_header_element, :od_topup_resp_input_message)
    end
end
