class QueryRequestsController < ApplicationController
  before_action :set_query_request, only: [:show, :edit, :update, :destroy]

  # GET /query_requests
  # GET /query_requests.json
  def index
    @query_requests = QueryRequest.all
  end

  # GET /query_requests/1
  # GET /query_requests/1.json
  def show
  end

  # GET /query_requests/new
  def new
    @query_request = QueryRequest.new
  end

  # GET /query_requests/1/edit
  def edit
  end

  # POST /query_requests
  # POST /query_requests.json
  def create
    @query_request = QueryRequest.new(query_request_params)

    respond_to do |format|
      if @query_request.save
        format.html { redirect_to @query_request, notice: 'Query request was successfully created.' }
        format.json { render :show, status: :created, location: @query_request }
      else
        format.html { render :new }
        format.json { render json: @query_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /query_requests/1
  # PATCH/PUT /query_requests/1.json
  def update
    respond_to do |format|
      if @query_request.update(query_request_params)
        format.html { redirect_to @query_request, notice: 'Query request was successfully updated.' }
        format.json { render :show, status: :ok, location: @query_request }
      else
        format.html { render :edit }
        format.json { render json: @query_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /query_requests/1
  # DELETE /query_requests/1.json
  def destroy
    @query_request.destroy
    respond_to do |format|
      format.html { redirect_to query_requests_url, notice: 'Query request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_query_request
      @query_request = QueryRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_request_params
      params.require(:query_request).permit(:header_element, :query_request_req_header, :header_request_id, :header_timestamp, :header_source_system, :credentials_element, :credentials_user, :credentials_password, :attributes_list, :attribute_element, :attribute_name, :attribute_value, :body_element, :body_query_request_req_element, :body_query_request_input_message, :body_query_request_id, :od_header_element, :od_query_request_input_message, :od_query_request_request_id, :od_query_request_return_code, :od_query_request_return_message, :od_query_request_timestamp, :od_query_request_body_element, :od_query_request_output_message, :od_query_request_request_id, :od_query_request_status)
    end
end
