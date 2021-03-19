require "rails_helper"

RSpec.describe StatusBancosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/status_bancos").to route_to("status_bancos#index")
    end

    it "routes to #new" do
      expect(:get => "/status_bancos/new").to route_to("status_bancos#new")
    end

    it "routes to #show" do
      expect(:get => "/status_bancos/1").to route_to("status_bancos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/status_bancos/1/edit").to route_to("status_bancos#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/status_bancos").to route_to("status_bancos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/status_bancos/1").to route_to("status_bancos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/status_bancos/1").to route_to("status_bancos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/status_bancos/1").to route_to("status_bancos#destroy", :id => "1")
    end
  end
end
