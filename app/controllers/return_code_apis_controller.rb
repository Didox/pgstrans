class ReturnCodeApisController < ApplicationController
  before_action :set_return_code_api, only: [:show, :edit, :update, :destroy]

  # GET /return_code_apis
  # GET /return_code_apis.json
  def index
    @return_code_apis = ReturnCodeApi.com_acesso(usuario_logado).order(partner_id: :asc, return_code: :asc)  

    @return_code_apis = @return_code_apis.where("codigo_erro_pagaso ilike '%#{params[:codigo_erro_pagaso].remove_injection}%'") if params[:codigo_erro_pagaso].present?
    @return_code_apis = @return_code_apis.where("return_code ilike '%#{params[:return_code].remove_injection}%'") if params[:return_code].present?
    @return_code_apis = @return_code_apis.where("return_description ilike '%#{params[:return_description].remove_injection}%'") if params[:return_description].present?
    @return_code_apis = @return_code_apis.where("error_description_pt ilike '%#{params[:error_description_pt].remove_injection}%'") if params[:error_description_pt].present?
    @return_code_apis = @return_code_apis.where("partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?

    options = {page: params[:page] || 1, per_page: 10}
    @return_code_apis = @return_code_apis.paginate(options)
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
    @return_code_api.responsavel = usuario_logado

    respond_to do |format|
      if @return_code_api.save
        format.html { redirect_to @return_code_api, notice: 'Código de Retorno da API foi criado com sucesso.' }
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
        format.html { redirect_to @return_code_api, notice: 'Código de Retorno da API foi atualizado com sucesso.' }
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
      format.html { redirect_to return_code_apis_url, notice: 'Código de Retorno da API foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_return_code_api
      @return_code_api = ReturnCodeApi.find(params[:id])
      @return_code_api.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_code_api_params
      params.require(:return_code_api).permit(:return_code, :codigo_erro_pagaso, :return_description, :error_description, :error_description_pt, :partner_id, :sucesso)
    end
end
