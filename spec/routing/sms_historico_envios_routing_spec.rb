require "rails_helper"

RSpec.describe SmsHistoricoEnviosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sms_historico_envios").to route_to("sms_historico_envios#index")
    end

    it "routes to #new" do
      expect(get: "/sms_historico_envios/new").to route_to("sms_historico_envios#new")
    end

    it "routes to #show" do
      expect(get: "/sms_historico_envios/1").to route_to("sms_historico_envios#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/sms_historico_envios/1/edit").to route_to("sms_historico_envios#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sms_historico_envios").to route_to("sms_historico_envios#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sms_historico_envios/1").to route_to("sms_historico_envios#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sms_historico_envios/1").to route_to("sms_historico_envios#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sms_historico_envios/1").to route_to("sms_historico_envios#destroy", id: "1")
    end
  end
end
