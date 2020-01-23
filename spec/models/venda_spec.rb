require 'rails_helper'

RSpec.describe Venda, type: :model do
  describe "Instance of object" do
    it { should belong_to :usuario }
    it { should belong_to :partner }

    it "respond_to methods" do
      expect(Venda.respond_to?(:venda_movicel)).to eq(true)
      expect(Venda.respond_to?(:venda_dstv)).to eq(true)
      expect(Venda.respond_to?(:venda_unitel)).to eq(true)
      
      venda = Venda.new
      expect(venda.respond_to?(:request_send_parse)).to eq(true)
      expect(venda.respond_to?(:response_get_parse)).to eq(true)
      expect(venda.respond_to?(:status_desc)).to eq(true)
      expect(venda.respond_to?(:sucesso?)).to eq(true)
      expect(venda.respond_to?(:request_id)).to eq(true)
      expect(venda.respond_to?(:status_movicel)).to eq(true)
      expect(venda.respond_to?(:status_dstv)).to eq(true)
    end
  end
end
