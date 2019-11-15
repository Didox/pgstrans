class QueryBalancesController < ApplicationController
  before_action :set_query_balance, only: [:show, :edit, :update, :destroy]

  # GET /query_balances
  # GET /query_balances.json
  def index
    @query_balances = QueryBalance.all
  end

  # GET /query_balances/1
  # GET /query_balances/1.json
  def show
  end

  # GET /query_balances/new
  def new
    @query_balance = QueryBalance.new
  end

  # GET /query_balances/1/edit
  def edit
  end

  # POST /query_balances
  # POST /query_balances.json
  def create
    @query_balance = QueryBalance.new(query_balance_params)

    respond_to do |format|
      if @query_balance.save
        format.html { redirect_to @query_balance, notice: 'Query balance was successfully created.' }
        format.json { render :show, status: :created, location: @query_balance }
      else
        format.html { render :new }
        format.json { render json: @query_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /query_balances/1
  # PATCH/PUT /query_balances/1.json
  def update
    respond_to do |format|
      if @query_balance.update(query_balance_params)
        format.html { redirect_to @query_balance, notice: 'Query balance was successfully updated.' }
        format.json { render :show, status: :ok, location: @query_balance }
      else
        format.html { render :edit }
        format.json { render json: @query_balance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /query_balances/1
  # DELETE /query_balances/1.json
  def destroy
    @query_balance.destroy
    respond_to do |format|
      format.html { redirect_to query_balances_url, notice: 'Query balance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_query_balance
      @query_balance = QueryBalance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_balance_params
      params.require(:query_balance).permit(:header_element, :query_balance_req_header, :header_request_id, :header_timestamp, :header_source_system, :credentials_element, :credentials_user, :credentials_password, :attributes_list, :attribute_element, :attribute_name, :attribute_value, :body_element, :body_query_balance_req_element, :body_query_balance_input_message, :od_header_element, :od_query_balance_input_message, :od_query_balance_request_id, :od_query_balance_return_code, :od_query_balance_return_message, :od_query_balance_timestamp, :od_query_balance_body_element, :od_query_balance_resp, :od_query_balance_output_message, :od_query_balance_request_id, :od_query_balance_balance)
    end
end
