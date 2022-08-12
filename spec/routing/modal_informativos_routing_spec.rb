require "rails_helper"

RSpec.describe ModalInformativosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/modal_informativos").to route_to("modal_informativos#index")
    end

    it "routes to #new" do
      expect(get: "/modal_informativos/new").to route_to("modal_informativos#new")
    end

    it "routes to #show" do
      expect(get: "/modal_informativos/1").to route_to("modal_informativos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/modal_informativos/1/edit").to route_to("modal_informativos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/modal_informativos").to route_to("modal_informativos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/modal_informativos/1").to route_to("modal_informativos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/modal_informativos/1").to route_to("modal_informativos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/modal_informativos/1").to route_to("modal_informativos#destroy", id: "1")
    end
  end
end
