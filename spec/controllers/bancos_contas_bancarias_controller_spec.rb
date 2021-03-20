require 'rails_helper'

RSpec.describe BancosContasBancariasController, type: :controller do

  describe "GET #index_bancos_clientes" do
    it "returns http success" do
      get :index_bancos_clientes
      expect(response).to have_http_status(:success)
    end
  end

end
