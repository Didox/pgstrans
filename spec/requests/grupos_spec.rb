require 'rails_helper'

RSpec.describe "Grupos", type: :request do
  describe "GET /grupos" do
    it "works! (now write some real specs)" do
      get grupos_path
      expect(response).to have_http_status(200)
    end
  end
end
