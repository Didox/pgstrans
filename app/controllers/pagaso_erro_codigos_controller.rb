class PagasoErroCodigosController < ApplicationController
  before_action :set_pagaso_erro_codigo, only: %i[ show edit update destroy ]

  # GET /pagaso_erro_codigos or /pagaso_erro_codigos.json
  def index
    @pagaso_erro_codigos = PagasoErroCodigo.all

    @pagaso_erro_codigos = PagasoErroCodigo.com_acesso(usuario_logado).order(de: :asc)

    @pagaso_erro_codigos = @pagaso_erro_codigos.where("de ilike '%#{params[:de].remove_injection}%'") if params[:de].present?
    @pagaso_erro_codigos = @pagaso_erro_codigos.where("para ilike '%#{params[:para].remove_injection}%'") if params[:para].present?
    @pagaso_erro_codigos = @pagaso_erro_codigos.where("mensagem ilike '%#{params[:mensagem].remove_injection}%'") if params[:mensagem].present?

    options = {page: params[:page] || 1, per_page: 10}
    @pagaso_erro_codigos = @pagaso_erro_codigos.paginate(options)
  end

  # GET /pagaso_erro_codigos/1 or /pagaso_erro_codigos/1.json
  def show
  end

  # GET /pagaso_erro_codigos/new
  def new
    @pagaso_erro_codigo = PagasoErroCodigo.new
  end

  # GET /pagaso_erro_codigos/1/edit
  def edit
  end

  # POST /pagaso_erro_codigos or /pagaso_erro_codigos.json
  def create
    @pagaso_erro_codigo = PagasoErroCodigo.new(pagaso_erro_codigo_params)
    @pagaso_erro_codigo.responsavel = usuario_logado

    respond_to do |format|
      if @pagaso_erro_codigo.save
        format.html { redirect_to pagaso_erro_codigo_url(@pagaso_erro_codigo), notice: "Código de ERRO Pagasó foi criado com sucesso." }
        format.json { render :show, status: :created, location: @pagaso_erro_codigo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pagaso_erro_codigo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagaso_erro_codigos/1 or /pagaso_erro_codigos/1.json
  def update
    respond_to do |format|
      if @pagaso_erro_codigo.update(pagaso_erro_codigo_params)
        format.html { redirect_to pagaso_erro_codigo_url(@pagaso_erro_codigo), notice: "Código de ERRO Pagasó foi alterado com sucesso." }
        format.json { render :show, status: :ok, location: @pagaso_erro_codigo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pagaso_erro_codigo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagaso_erro_codigos/1 or /pagaso_erro_codigos/1.json
  def destroy
    @pagaso_erro_codigo.destroy

    respond_to do |format|
      format.html { redirect_to pagaso_erro_codigos_url, notice: "Código de ERRO Pagasó foi apagado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagaso_erro_codigo
      @pagaso_erro_codigo = PagasoErroCodigo.find(params[:id])
      @pagaso_erro_codigo.responsavel = usuario_logado
    end

    # Only allow a list of trusted parameters through.
    def pagaso_erro_codigo_params
      params.require(:pagaso_erro_codigo).permit(:de, :para, :mensagem)
    end
end
