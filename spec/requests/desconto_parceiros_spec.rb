require 'rails_helper'

RSpec.describe "DescontoParceiros", type: :request do
  describe "GET /desconto_parceiros" do
    it "works! (now write some real specs)" do
      get desconto_parceiros_path
      expect(response).to have_http_status(200)
    end
  end
end
