require "rails_helper"

RSpec.describe GruposController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/grupos").to route_to("grupos#index")
    end

    it "routes to #new" do
      expect(:get => "/grupos/new").to route_to("grupos#new")
    end

    it "routes to #show" do
      expect(:get => "/grupos/1").to route_to("grupos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/grupos/1/edit").to route_to("grupos#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/grupos").to route_to("grupos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/grupos/1").to route_to("grupos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/grupos/1").to route_to("grupos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/grupos/1").to route_to("grupos#destroy", :id => "1")
    end
  end
end
