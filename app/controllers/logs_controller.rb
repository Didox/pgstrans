class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]

  # GET /logs
  # GET /logs.json
  def index
    @logs = Log.all


    if params[:nome].present?
      @logs = @logs.where("lower(responsavel) ilike ? ", "%#{params[:nome]}%")
      @busca = true
    end

    if params[:titulo].present?
      @logs = @logs.where("lower(titulo) ilike ? ", "%#{params[:titulo]}%") 
      @busca = true
    end

    if params[:dados_alterados].present?
      @logs = @logs.where("lower(dados_alterados) ilike ? ", "%#{params[:dados_alterados]}%")
      @busca = true
    end

    if params[:created_at_de].present?
      @logs = @logs.where("created_at >= ?", params[:created_at_de].to_datetime.beginning_of_day)
      @busca = true
    end

    if params[:created_at_ate].present? 
      @logs = @logs.where("created_at <= ?", params[:created_at_ate].to_datetime.end_of_day)
      @busca = true
    end

    options = {page: params[:page] || 1, per_page: 5}
    @logs = @logs.paginate(options)
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # GET /logs/new
  def new
    @log = Log.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:titulo, :responsavel, :dados_alterados)
    end
end
