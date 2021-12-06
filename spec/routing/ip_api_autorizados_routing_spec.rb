require "rails_helper"

RSpec.describe IpApiAutorizadosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/ip_api_autorizados").to route_to("ip_api_autorizados#index")
    end

    it "routes to #new" do
      expect(get: "/ip_api_autorizados/new").to route_to("ip_api_autorizados#new")
    end

    it "routes to #show" do
      expect(get: "/ip_api_autorizados/1").to route_to("ip_api_autorizados#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/ip_api_autorizados/1/edit").to route_to("ip_api_autorizados#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/ip_api_autorizados").to route_to("ip_api_autorizados#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/ip_api_autorizados/1").to route_to("ip_api_autorizados#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/ip_api_autorizados/1").to route_to("ip_api_autorizados#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/ip_api_autorizados/1").to route_to("ip_api_autorizados#destroy", id: "1")
    end
  end
end
