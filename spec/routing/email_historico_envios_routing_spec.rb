require "rails_helper"

RSpec.describe EmailHistoricoEnviosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/email_historico_envios").to route_to("email_historico_envios#index")
    end

    it "routes to #new" do
      expect(get: "/email_historico_envios/new").to route_to("email_historico_envios#new")
    end

    it "routes to #show" do
      expect(get: "/email_historico_envios/1").to route_to("email_historico_envios#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/email_historico_envios/1/edit").to route_to("email_historico_envios#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/email_historico_envios").to route_to("email_historico_envios#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/email_historico_envios/1").to route_to("email_historico_envios#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/email_historico_envios/1").to route_to("email_historico_envios#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/email_historico_envios/1").to route_to("email_historico_envios#destroy", id: "1")
    end
  end
end
