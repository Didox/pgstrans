require 'rails_helper'

RSpec.describe "PainelVendas", type: :request do
  describe "GET /painel" do
    it "returns http success" do
      get "/painel_vendas/painel"
      expect(response).to have_http_status(:success)
    end
  end

end
