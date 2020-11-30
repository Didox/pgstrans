require 'rails_helper'

RSpec.describe "LoopLogs", type: :request do
  describe "GET /loop_logs" do
    it "works! (now write some real specs)" do
      get loop_logs_path
      expect(response).to have_http_status(200)
    end
  end
end
