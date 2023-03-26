require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/pagamento_referencia", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # PagamentoReferencia. As you add validations to PagamentoReferencia, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      PagamentoReferencia.create! valid_attributes
      get pagamento_referencia_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      pagamento_referencia = PagamentoReferencia.create! valid_attributes
      get pagamento_referencia_url(pagamento_referencia)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_pagamento_referencia_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      pagamento_referencia = PagamentoReferencia.create! valid_attributes
      get edit_pagamento_referencia_url(pagamento_referencia)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new PagamentoReferencia" do
        expect {
          post pagamento_referencia_url, params: { pagamento_referencia: valid_attributes }
        }.to change(PagamentoReferencia, :count).by(1)
      end

      it "redirects to the created pagamento_referencia" do
        post pagamento_referencia_url, params: { pagamento_referencia: valid_attributes }
        expect(response).to redirect_to(pagamento_referencia_url(PagamentoReferencia.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new PagamentoReferencia" do
        expect {
          post pagamento_referencia_url, params: { pagamento_referencia: invalid_attributes }
        }.to change(PagamentoReferencia, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post pagamento_referencia_url, params: { pagamento_referencia: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested pagamento_referencia" do
        pagamento_referencia = PagamentoReferencia.create! valid_attributes
        patch pagamento_referencia_url(pagamento_referencia), params: { pagamento_referencia: new_attributes }
        pagamento_referencia.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the pagamento_referencia" do
        pagamento_referencia = PagamentoReferencia.create! valid_attributes
        patch pagamento_referencia_url(pagamento_referencia), params: { pagamento_referencia: new_attributes }
        pagamento_referencia.reload
        expect(response).to redirect_to(pagamento_referencia_url(pagamento_referencia))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        pagamento_referencia = PagamentoReferencia.create! valid_attributes
        patch pagamento_referencia_url(pagamento_referencia), params: { pagamento_referencia: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested pagamento_referencia" do
      pagamento_referencia = PagamentoReferencia.create! valid_attributes
      expect {
        delete pagamento_referencia_url(pagamento_referencia)
      }.to change(PagamentoReferencia, :count).by(-1)
    end

    it "redirects to the pagamento_referencia list" do
      pagamento_referencia = PagamentoReferencia.create! valid_attributes
      delete pagamento_referencia_url(pagamento_referencia)
      expect(response).to redirect_to(pagamento_referencia_url)
    end
  end
end
