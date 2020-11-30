require "rails_helper"

RSpec.describe LoopLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/loop_logs").to route_to("loop_logs#index")
    end

    it "routes to #new" do
      expect(:get => "/loop_logs/new").to route_to("loop_logs#new")
    end

    it "routes to #show" do
      expect(:get => "/loop_logs/1").to route_to("loop_logs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/loop_logs/1/edit").to route_to("loop_logs#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/loop_logs").to route_to("loop_logs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/loop_logs/1").to route_to("loop_logs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/loop_logs/1").to route_to("loop_logs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/loop_logs/1").to route_to("loop_logs#destroy", :id => "1")
    end
  end
end
