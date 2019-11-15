class ReturnCodeApisController < ApplicationController
  before_action :set_return_code_api, only: [:show, :edit, :update, :destroy]

  # GET /return_code_apis
  # GET /return_code_apis.json
  def index
    @return_code_apis = ReturnCodeApi.all
  end

  # GET /return_code_apis/1
  # GET /return_code_apis/1.json
  def show
  end

  # GET /return_code_apis/new
  def new
    @return_code_api = ReturnCodeApi.new
  end

  # GET /return_code_apis/1/edit
  def edit
  end

  # POST /return_code_apis
  # POST /return_code_apis.json
  def create
    @return_code_api = ReturnCodeApi.new(return_code_api_params)

    respond_to do |format|
      if @return_code_api.save
        format.html { redirect_to @return_code_api, notice: 'Return code api was successfully created.' }
        format.json { render :show, status: :created, location: @return_code_api }
      else
        format.html { render :new }
        format.json { render json: @return_code_api.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /return_code_apis/1
  # PATCH/PUT /return_code_apis/1.json
  def update
    respond_to do |format|
      if @return_code_api.update(return_code_api_params)
        format.html { redirect_to @return_code_api, notice: 'Return code api was successfully updated.' }
        format.json { render :show, status: :ok, location: @return_code_api }
      else
        format.html { render :edit }
        format.json { render json: @return_code_api.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_code_apis/1
  # DELETE /return_code_apis/1.json
  def destroy
    @return_code_api.destroy
    respond_to do |format|
      format.html { redirect_to return_code_apis_url, notice: 'Return code api was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return_code_api
      @return_code_api = ReturnCodeApi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_code_api_params
      params.require(:return_code_api).permit(:return_code, :return_description, :error_description, :error_description_pt, :partner_code)
    end
end
