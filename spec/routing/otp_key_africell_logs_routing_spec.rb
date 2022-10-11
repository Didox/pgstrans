require "rails_helper"

RSpec.describe OtpKeyAfricellLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/otp_key_africell_logs").to route_to("otp_key_africell_logs#index")
    end

    it "routes to #new" do
      expect(get: "/otp_key_africell_logs/new").to route_to("otp_key_africell_logs#new")
    end

    it "routes to #show" do
      expect(get: "/otp_key_africell_logs/1").to route_to("otp_key_africell_logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/otp_key_africell_logs/1/edit").to route_to("otp_key_africell_logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/otp_key_africell_logs").to route_to("otp_key_africell_logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/otp_key_africell_logs/1").to route_to("otp_key_africell_logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/otp_key_africell_logs/1").to route_to("otp_key_africell_logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/otp_key_africell_logs/1").to route_to("otp_key_africell_logs#destroy", id: "1")
    end
  end
end
