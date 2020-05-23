class BancosController < ApplicationController
  before_action :set_banco, only: [:show, :edit, :update, :destroy]

  # GET /bancos
  # GET /bancos.json
  def index
    @bancos = Banco.all
    #@bancos = Banco.com_acesso(usuario_logado)

    options = {page: params[:page] || 1, per_page: 10}
    @bancos = @bancos.paginate(options) 
  end

  # GET /bancos/1
  # GET /bancos/1.json
  def show
  end

  # GET /bancos/new
  def new
    @banco = Banco.new
  end

  # GET /bancos/1/edit
  def edit
  end

  # POST /bancos
  # POST /bancos.json
  def create
    @banco = Banco.new(banco_params)
    @banco.responsavel = usuario_logado

    respond_to do |format|
      if @banco.save
        format.html { redirect_to @banco, notice: 'Banco foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @banco }
      else
        format.html { render :new }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bancos/1
  # PATCH/PUT /bancos/1.json
  def update
    respond_to do |format|
      if @banco.update(banco_params)
        format.html { redirect_to @banco, notice: 'Banco foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @banco }
      else
        format.html { render :edit }
        format.json { render json: @banco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bancos/1
  # DELETE /bancos/1.json
  def destroy
    @banco.destroy
    respond_to do |format|
      format.html { redirect_to bancos_url, notice: 'Banco foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banco
      @banco = Banco.find(params[:id])
      @banco.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def banco_params
      params.require(:banco).permit(:nome, :sigla, :morada_sede, :telefone_sede, :fax_sede, :morada_escritorio, :telefone_escritorio, :fax_escritorio, :website, :email, :logomarca)
    end
end
