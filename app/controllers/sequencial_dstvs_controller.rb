class SequencialDstvsController < ApplicationController
  before_action :set_sequencial_dstv, only: [:show, :edit, :update, :destroy]

  # GET /sequencial_dstvs
  # GET /sequencial_dstvs.json
  def index
    @sequencial_dstvs = SequencialDstv.all.order(id: :desc)

    @sequencial_dstvs = @sequencial_dstvs.where("numero = ?", params[:numero]) if params[:numero].present?
    if params[:created_at].present?
      @sequencial_dstvs = @sequencial_dstvs.where("created_at >= ?", SqlDate.sql_parse(params[:created_at].to_datetime.beginning_of_day)) 
      @sequencial_dstvs = @sequencial_dstvs.where("created_at <= ?", SqlDate.sql_parse(params[:created_at].to_datetime.end_of_day))
    end
    @sequencial_dstvs = @sequencial_dstvs.where("request_body ilike '%#{params[:request_body].remove_injection}%'") if params[:request_body].present?
    @sequencial_dstvs = @sequencial_dstvs.where("response_body ilike '%#{params[:response_body].remove_injection}%'") if params[:response_body].present?

    @sequencial_dstvs_total = @sequencial_dstvs.count
    options = {page: params[:page] || 1, per_page: 10}
    @sequencial_dstvs = @sequencial_dstvs.paginate(options)
  end

  # GET /sequencial_dstvs/1
  # GET /sequencial_dstvs/1.json
  def show
  end

  # GET /sequencial_dstvs/new
  def new
    @sequencial_dstv = SequencialDstv.new
  end

  # GET /sequencial_dstvs/1/edit
  def edit
  end

  # POST /sequencial_dstvs
  # POST /sequencial_dstvs.json
  def create
    @sequencial_dstv = SequencialDstv.new(sequencial_dstv_params)

    respond_to do |format|
      if @sequencial_dstv.save
        format.html { redirect_to @sequencial_dstv, notice: 'Sequencial dstv foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @sequencial_dstv }
      else
        format.html { render :new }
        format.json { render json: @sequencial_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sequencial_dstvs/1
  # PATCH/PUT /sequencial_dstvs/1.json
  def update
    respond_to do |format|
      if @sequencial_dstv.update(sequencial_dstv_params)
        format.html { redirect_to @sequencial_dstv, notice: 'Sequencial dstv foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @sequencial_dstv }
      else
        format.html { render :edit }
        format.json { render json: @sequencial_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequencial_dstvs/1
  # DELETE /sequencial_dstvs/1.json
  def destroy
    @sequencial_dstv.destroy
    respond_to do |format|
      format.html { redirect_to sequencial_dstvs_url, notice: 'Sequencial dstv foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_sequencial_dstv
      @sequencial_dstv = SequencialDstv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sequencial_dstv_params
      params.require(:sequencial_dstv).permit(:numero)
    end
end
