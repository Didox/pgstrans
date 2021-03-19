require 'rails_helper'

RSpec.describe "StatusBancos", type: :request do
  describe "GET /status_bancos" do
    it "works! (now write some real specs)" do
      get status_bancos_path
      expect(response).to have_http_status(200)
    end
  end
end
