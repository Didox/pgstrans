require "rails_helper"

RSpec.describe UnitelSequencesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/unitel_sequences").to route_to("unitel_sequences#index")
    end

    it "routes to #new" do
      expect(:get => "/unitel_sequences/new").to route_to("unitel_sequences#new")
    end

    it "routes to #show" do
      expect(:get => "/unitel_sequences/1").to route_to("unitel_sequences#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/unitel_sequences/1/edit").to route_to("unitel_sequences#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/unitel_sequences").to route_to("unitel_sequences#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/unitel_sequences/1").to route_to("unitel_sequences#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/unitel_sequences/1").to route_to("unitel_sequences#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/unitel_sequences/1").to route_to("unitel_sequences#destroy", :id => "1")
    end
  end
end
