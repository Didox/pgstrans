class OtpKeyAfricellLogsController < ApplicationController
  def index
    options = {page: params[:page] || 1, per_page: 10}
    @otp_key_africell_logs = OtpKeyAfricellLog.all.paginate(options)  
  end
end
