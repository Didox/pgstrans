class ErrorsController < ApplicationController
  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end

  def unprocessable_entity
    render status: :unprocessable_entity
  end
    
  def show
    status_code = params[:code] || 500
    render_error(status_code.to_i)
  end

  private

  def render_error(status)
    respond_to do |format|
      format.html { render status: status }
      format.all { render plain: "Error #{status}", status: status }
    end
  end


end