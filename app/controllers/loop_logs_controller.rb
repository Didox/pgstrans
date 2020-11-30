class LoopLogsController < ApplicationController
  before_action :set_loop_log, only: [:show, :edit, :update, :destroy]
  before_action :set_movicel_loop

  # GET /loop_logs
  # GET /loop_logs.json
  def index
    @loop_logs = LoopLog.all

    options = {page: params[:page] || 1, per_page: 10}
    @loop_logs = @loop_logs.paginate(options)
  end

  # GET /loop_logs/1
  # GET /loop_logs/1.json
  def show
  end

  # DELETE /loop_logs/1
  # DELETE /loop_logs/1.json
  def destroy
    @loop_log.destroy
    respond_to do |format|
      format.html { redirect_to loop_logs_url, notice: 'Loop log foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def set_movicel_loop
      @movicel_loop = MovicelLoop.find(params[:movicel_loop_id])
    end

    def set_loop_log
      @loop_log = LoopLog.find(params[:id])
    end

    def loop_log_params
      params.require(:loop_log).permit(:request, :response)
    end
end
