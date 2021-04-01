require 'rails_helper'

RSpec.describe VendasConciliacaoController, type: :controller do

  describe "GET #index_vendas_conciliacao" do
    it "returns http success" do
      get :index_vendas_conciliacao
      expect(response).to have_http_status(:success)
    end
  end

end
