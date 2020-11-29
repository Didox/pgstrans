require "rails_helper"

RSpec.describe MovicelLoopsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/movicel_loops").to route_to("movicel_loops#index")
    end

    it "routes to #new" do
      expect(:get => "/movicel_loops/new").to route_to("movicel_loops#new")
    end

    it "routes to #show" do
      expect(:get => "/movicel_loops/1").to route_to("movicel_loops#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/movicel_loops/1/edit").to route_to("movicel_loops#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/movicel_loops").to route_to("movicel_loops#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/movicel_loops/1").to route_to("movicel_loops#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/movicel_loops/1").to route_to("movicel_loops#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/movicel_loops/1").to route_to("movicel_loops#destroy", :id => "1")
    end
  end
end
