require "rails_helper"

RSpec.describe LogVendasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/log_vendas").to route_to("log_vendas#index")
    end

    it "routes to #new" do
      expect(:get => "/log_vendas/new").to route_to("log_vendas#new")
    end

    it "routes to #show" do
      expect(:get => "/log_vendas/1").to route_to("log_vendas#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/log_vendas/1/edit").to route_to("log_vendas#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/log_vendas").to route_to("log_vendas#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/log_vendas/1").to route_to("log_vendas#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/log_vendas/1").to route_to("log_vendas#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/log_vendas/1").to route_to("log_vendas#destroy", :id => "1")
    end
  end
end
