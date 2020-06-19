require 'rails_helper'

RSpec.describe "PagamentosFaturasDstvs", type: :request do
  describe "GET /pagamentos_faturas_dstvs" do
    it "works! (now write some real specs)" do
      get pagamentos_faturas_dstvs_path
      expect(response).to have_http_status(200)
    end
  end
end
