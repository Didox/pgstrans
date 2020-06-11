require "rails_helper"

RSpec.describe SequencialDstvsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/sequencial_dstvs").to route_to("sequencial_dstvs#index")
    end

    it "routes to #new" do
      expect(:get => "/sequencial_dstvs/new").to route_to("sequencial_dstvs#new")
    end

    it "routes to #show" do
      expect(:get => "/sequencial_dstvs/1").to route_to("sequencial_dstvs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/sequencial_dstvs/1/edit").to route_to("sequencial_dstvs#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/sequencial_dstvs").to route_to("sequencial_dstvs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/sequencial_dstvs/1").to route_to("sequencial_dstvs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/sequencial_dstvs/1").to route_to("sequencial_dstvs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/sequencial_dstvs/1").to route_to("sequencial_dstvs#destroy", :id => "1")
    end
  end
end
