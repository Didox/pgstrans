require 'rails_helper'

RSpec.describe "MovicelLoops", type: :request do
  describe "GET /movicel_loops" do
    it "works! (now write some real specs)" do
      get movicel_loops_path
      expect(response).to have_http_status(200)
    end
  end
end
