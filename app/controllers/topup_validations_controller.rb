class TopupValidationsController < ApplicationController
  before_action :set_topup_validation, only: [:show, :edit, :update, :destroy]

  # GET /topup_validations
  # GET /topup_validations.json
  def index
    @topup_validations = TopupValidation.all
  end

  # GET /topup_validations/1
  # GET /topup_validations/1.json
  def show
  end

  # GET /topup_validations/new
  def new
    @topup_validation = TopupValidation.new
  end

  # GET /topup_validations/1/edit
  def edit
  end

  # POST /topup_validations
  # POST /topup_validations.json
  def create
    @topup_validation = TopupValidation.new(topup_validation_params)

    respond_to do |format|
      if @topup_validation.save
        format.html { redirect_to @topup_validation, notice: 'Topup validation was successfully created.' }
        format.json { render :show, status: :created, location: @topup_validation }
      else
        format.html { render :new }
        format.json { render json: @topup_validation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topup_validations/1
  # PATCH/PUT /topup_validations/1.json
  def update
    respond_to do |format|
      if @topup_validation.update(topup_validation_params)
        format.html { redirect_to @topup_validation, notice: 'Topup validation was successfully updated.' }
        format.json { render :show, status: :ok, location: @topup_validation }
      else
        format.html { render :edit }
        format.json { render json: @topup_validation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topup_validations/1
  # DELETE /topup_validations/1.json
  def destroy
    @topup_validation.destroy
    respond_to do |format|
      format.html { redirect_to topup_validations_url, notice: 'Topup validation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topup_validation
      @topup_validation = TopupValidation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topup_validation_params
      params.require(:topup_validation).permit(:spree_order_id, :spree_products_id, :header_element, :validate_topup_req_header_element, :request_id, :header_timestamp, :header_source_system, :credentials_element, :credentials_user, :credentials_password, :attributes_list, :attributes_element, :attribute_name, :attribute_value, :body_element, :validation_topup_req, :validate_topup_input_message, :validate_topup_req_body_type, :validate_topup_req_body_amount, :validate_topup_req_body_msisdn, :op_header, :op_validate_topup_input_message, :op_request_id, :op_return_code, :op_return_message, :op_timestamp, :op_body_element, :op_body_validate_topup_resp, :op_body_validate_topup_output_message, :qtde_retry)
    end
end
