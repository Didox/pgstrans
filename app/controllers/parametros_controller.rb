class ParametrosController < ApplicationController
  before_action :set_parametro, only: [:show, :edit, :update, :destroy]

  # GET /parametros
  # GET /parametros.json
  def index
    @parametros = Parametro.com_acesso(usuario_logado)

    @parametros = @parametros.all.joins("inner join partners on partners.id = parametros.partner_id").reorder("partners.name asc")

    options = {page: params[:page] || 1, per_page: 10}
    @parametros = @parametros.paginate(options)    
  end

  # GET /parametros/1
  # GET /parametros/1.json
  def show
  end

  # GET /parametros/new
  def new
    @parametro = Parametro.new
  end

  # GET /parametros/1/edit
  def edit
  end

  # POST /parametros
  # POST /parametros.json
  def create
    @parametro = Parametro.new(partner_id: params[:parametro][:partner_id])
    @parametro.dados = params[:parametro].to_json
    @parametro.responsavel = usuario_logado

    respond_to do |format|
      if @parametro.save
        format.html { redirect_to edit_parametro_url(@parametro), notice: 'Parametro foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @parametro }
      else
        format.html { render :new }
        format.json { render json: @parametro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parametros/1
  # PATCH/PUT /parametros/1.json
  def update
    respond_to do |format|
      @parametro.dados = params[:parametro].to_json
      @parametro.responsavel = usuario_logado
      if @parametro.save
        format.html { redirect_to @parametro, notice: 'Parametro foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @parametro }
      else
        format.html { render :edit }
        format.json { render json: @parametro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parametros/1
  # DELETE /parametros/1.json
  def destroy
    @parametro.destroy
    respond_to do |format|
      format.html { redirect_to parametros_url, notice: 'Parametro foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_parametro
      @parametro = Parametro.find(params[:id])
      @parametro.responsavel = usuario_logado
    end
end
