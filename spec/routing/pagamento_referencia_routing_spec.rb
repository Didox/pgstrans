require "rails_helper"

RSpec.describe PagamentoReferenciaController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/pagamento_referencia").to route_to("pagamento_referencia#index")
    end

    it "routes to #new" do
      expect(get: "/pagamento_referencia/new").to route_to("pagamento_referencia#new")
    end

    it "routes to #show" do
      expect(get: "/pagamento_referencia/1").to route_to("pagamento_referencia#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/pagamento_referencia/1/edit").to route_to("pagamento_referencia#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/pagamento_referencia").to route_to("pagamento_referencia#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/pagamento_referencia/1").to route_to("pagamento_referencia#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/pagamento_referencia/1").to route_to("pagamento_referencia#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/pagamento_referencia/1").to route_to("pagamento_referencia#destroy", id: "1")
    end
  end
end
