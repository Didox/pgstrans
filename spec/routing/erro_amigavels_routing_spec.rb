require "rails_helper"

RSpec.describe ErroAmigavelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/erro_amigavels").to route_to("erro_amigavels#index")
    end

    it "routes to #new" do
      expect(:get => "/erro_amigavels/new").to route_to("erro_amigavels#new")
    end

    it "routes to #show" do
      expect(:get => "/erro_amigavels/1").to route_to("erro_amigavels#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/erro_amigavels/1/edit").to route_to("erro_amigavels#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/erro_amigavels").to route_to("erro_amigavels#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/erro_amigavels/1").to route_to("erro_amigavels#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/erro_amigavels/1").to route_to("erro_amigavels#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/erro_amigavels/1").to route_to("erro_amigavels#destroy", :id => "1")
    end
  end
end
