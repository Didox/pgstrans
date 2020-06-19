require "rails_helper"

RSpec.describe PagamentosFaturasDstvsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/pagamentos_faturas_dstvs").to route_to("pagamentos_faturas_dstvs#index")
    end

    it "routes to #new" do
      expect(:get => "/pagamentos_faturas_dstvs/new").to route_to("pagamentos_faturas_dstvs#new")
    end

    it "routes to #show" do
      expect(:get => "/pagamentos_faturas_dstvs/1").to route_to("pagamentos_faturas_dstvs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pagamentos_faturas_dstvs/1/edit").to route_to("pagamentos_faturas_dstvs#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/pagamentos_faturas_dstvs").to route_to("pagamentos_faturas_dstvs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pagamentos_faturas_dstvs/1").to route_to("pagamentos_faturas_dstvs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pagamentos_faturas_dstvs/1").to route_to("pagamentos_faturas_dstvs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pagamentos_faturas_dstvs/1").to route_to("pagamentos_faturas_dstvs#destroy", :id => "1")
    end
  end
end
