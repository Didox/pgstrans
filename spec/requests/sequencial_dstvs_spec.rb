require 'rails_helper'

RSpec.describe "SequencialDstvs", type: :request do
  describe "GET /sequencial_dstvs" do
    it "works! (now write some real specs)" do
      get sequencial_dstvs_path
      expect(response).to have_http_status(200)
    end
  end
end
