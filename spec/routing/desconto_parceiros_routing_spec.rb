require "rails_helper"

RSpec.describe DescontoParceirosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/desconto_parceiros").to route_to("desconto_parceiros#index")
    end

    it "routes to #new" do
      expect(:get => "/desconto_parceiros/new").to route_to("desconto_parceiros#new")
    end

    it "routes to #show" do
      expect(:get => "/desconto_parceiros/1").to route_to("desconto_parceiros#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/desconto_parceiros/1/edit").to route_to("desconto_parceiros#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/desconto_parceiros").to route_to("desconto_parceiros#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/desconto_parceiros/1").to route_to("desconto_parceiros#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/desconto_parceiros/1").to route_to("desconto_parceiros#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/desconto_parceiros/1").to route_to("desconto_parceiros#destroy", :id => "1")
    end
  end
end
