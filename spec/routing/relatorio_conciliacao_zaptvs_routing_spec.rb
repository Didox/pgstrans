require "rails_helper"

RSpec.describe RelatorioConciliacaoZaptvsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/relatorio_conciliacao_zaptvs").to route_to("relatorio_conciliacao_zaptvs#index")
    end

    it "routes to #new" do
      expect(:get => "/relatorio_conciliacao_zaptvs/new").to route_to("relatorio_conciliacao_zaptvs#new")
    end

    it "routes to #show" do
      expect(:get => "/relatorio_conciliacao_zaptvs/1").to route_to("relatorio_conciliacao_zaptvs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/relatorio_conciliacao_zaptvs/1/edit").to route_to("relatorio_conciliacao_zaptvs#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/relatorio_conciliacao_zaptvs").to route_to("relatorio_conciliacao_zaptvs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/relatorio_conciliacao_zaptvs/1").to route_to("relatorio_conciliacao_zaptvs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/relatorio_conciliacao_zaptvs/1").to route_to("relatorio_conciliacao_zaptvs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/relatorio_conciliacao_zaptvs/1").to route_to("relatorio_conciliacao_zaptvs#destroy", :id => "1")
    end
  end
end
