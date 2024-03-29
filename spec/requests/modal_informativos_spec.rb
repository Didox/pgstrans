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

RSpec.describe "/modal_informativos", type: :request do
  
  # ModalInformativo. As you add validations to ModalInformativo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ModalInformativo.create! valid_attributes
      get modal_informativos_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      modal_informativo = ModalInformativo.create! valid_attributes
      get modal_informativo_url(modal_informativo)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_modal_informativo_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      modal_informativo = ModalInformativo.create! valid_attributes
      get edit_modal_informativo_url(modal_informativo)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ModalInformativo" do
        expect {
          post modal_informativos_url, params: { modal_informativo: valid_attributes }
        }.to change(ModalInformativo, :count).by(1)
      end

      it "redirects to the created modal_informativo" do
        post modal_informativos_url, params: { modal_informativo: valid_attributes }
        expect(response).to redirect_to(modal_informativo_url(ModalInformativo.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ModalInformativo" do
        expect {
          post modal_informativos_url, params: { modal_informativo: invalid_attributes }
        }.to change(ModalInformativo, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post modal_informativos_url, params: { modal_informativo: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested modal_informativo" do
        modal_informativo = ModalInformativo.create! valid_attributes
        patch modal_informativo_url(modal_informativo), params: { modal_informativo: new_attributes }
        modal_informativo.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the modal_informativo" do
        modal_informativo = ModalInformativo.create! valid_attributes
        patch modal_informativo_url(modal_informativo), params: { modal_informativo: new_attributes }
        modal_informativo.reload
        expect(response).to redirect_to(modal_informativo_url(modal_informativo))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        modal_informativo = ModalInformativo.create! valid_attributes
        patch modal_informativo_url(modal_informativo), params: { modal_informativo: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested modal_informativo" do
      modal_informativo = ModalInformativo.create! valid_attributes
      expect {
        delete modal_informativo_url(modal_informativo)
      }.to change(ModalInformativo, :count).by(-1)
    end

    it "redirects to the modal_informativos list" do
      modal_informativo = ModalInformativo.create! valid_attributes
      delete modal_informativo_url(modal_informativo)
      expect(response).to redirect_to(modal_informativos_url)
    end
  end
end
