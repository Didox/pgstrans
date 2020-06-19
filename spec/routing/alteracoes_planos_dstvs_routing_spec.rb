require "rails_helper"

RSpec.describe AlteracoesPlanosDstvsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/alteracoes_planos_dstvs").to route_to("alteracoes_planos_dstvs#index")
    end

    it "routes to #new" do
      expect(:get => "/alteracoes_planos_dstvs/new").to route_to("alteracoes_planos_dstvs#new")
    end

    it "routes to #show" do
      expect(:get => "/alteracoes_planos_dstvs/1").to route_to("alteracoes_planos_dstvs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/alteracoes_planos_dstvs/1/edit").to route_to("alteracoes_planos_dstvs#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/alteracoes_planos_dstvs").to route_to("alteracoes_planos_dstvs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/alteracoes_planos_dstvs/1").to route_to("alteracoes_planos_dstvs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/alteracoes_planos_dstvs/1").to route_to("alteracoes_planos_dstvs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/alteracoes_planos_dstvs/1").to route_to("alteracoes_planos_dstvs#destroy", :id => "1")
    end
  end
end
