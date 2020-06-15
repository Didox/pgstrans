require 'rails_helper'

RSpec.describe "LogVendas", type: :request do
  describe "GET /log_vendas" do
    it "works! (now write some real specs)" do
      get log_vendas_path
      expect(response).to have_http_status(200)
    end
  end
end
