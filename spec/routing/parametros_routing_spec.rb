require "rails_helper"

RSpec.describe ParametrosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/parametros").to route_to("parametros#index")
    end

    it "routes to #new" do
      expect(:get => "/parametros/new").to route_to("parametros#new")
    end

    it "routes to #show" do
      expect(:get => "/parametros/1").to route_to("parametros#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/parametros/1/edit").to route_to("parametros#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/parametros").to route_to("parametros#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/parametros/1").to route_to("parametros#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/parametros/1").to route_to("parametros#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/parametros/1").to route_to("parametros#destroy", :id => "1")
    end
  end
end
