require 'rails_helper'

RSpec.describe "AlteracoesPlanosDstvs", type: :request do
  describe "GET /alteracoes_planos_dstvs" do
    it "works! (now write some real specs)" do
      get alteracoes_planos_dstvs_path
      expect(response).to have_http_status(200)
    end
  end
end
