require 'rails_helper'

RSpec.describe "ErroAmigavels", type: :request do
  describe "GET /erro_amigavels" do
    it "works! (now write some real specs)" do
      get erro_amigavels_path
      expect(response).to have_http_status(200)
    end
  end
end
