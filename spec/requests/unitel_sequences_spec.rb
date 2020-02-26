require 'rails_helper'

RSpec.describe "UnitelSequences", type: :request do
  describe "GET /unitel_sequences" do
    it "works! (now write some real specs)" do
      get unitel_sequences_path
      expect(response).to have_http_status(200)
    end
  end
end
