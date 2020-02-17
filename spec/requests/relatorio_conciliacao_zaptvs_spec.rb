require 'rails_helper'

RSpec.describe "RelatorioConciliacaoZaptvs", type: :request do
  describe "GET /relatorio_conciliacao_zaptvs" do
    it "works! (now write some real specs)" do
      get relatorio_conciliacao_zaptvs_path
      expect(response).to have_http_status(200)
    end
  end
end
