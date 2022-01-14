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

RSpec.describe "/email_historico_envios", type: :request do
  
  # EmailHistoricoEnvio. As you add validations to EmailHistoricoEnvio, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      EmailHistoricoEnvio.create! valid_attributes
      get email_historico_envios_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
      get email_historico_envio_url(email_historico_envio)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_email_historico_envio_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
      get edit_email_historico_envio_url(email_historico_envio)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new EmailHistoricoEnvio" do
        expect {
          post email_historico_envios_url, params: { email_historico_envio: valid_attributes }
        }.to change(EmailHistoricoEnvio, :count).by(1)
      end

      it "redirects to the created email_historico_envio" do
        post email_historico_envios_url, params: { email_historico_envio: valid_attributes }
        expect(response).to redirect_to(email_historico_envio_url(EmailHistoricoEnvio.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new EmailHistoricoEnvio" do
        expect {
          post email_historico_envios_url, params: { email_historico_envio: invalid_attributes }
        }.to change(EmailHistoricoEnvio, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post email_historico_envios_url, params: { email_historico_envio: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested email_historico_envio" do
        email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
        patch email_historico_envio_url(email_historico_envio), params: { email_historico_envio: new_attributes }
        email_historico_envio.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the email_historico_envio" do
        email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
        patch email_historico_envio_url(email_historico_envio), params: { email_historico_envio: new_attributes }
        email_historico_envio.reload
        expect(response).to redirect_to(email_historico_envio_url(email_historico_envio))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
        patch email_historico_envio_url(email_historico_envio), params: { email_historico_envio: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested email_historico_envio" do
      email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
      expect {
        delete email_historico_envio_url(email_historico_envio)
      }.to change(EmailHistoricoEnvio, :count).by(-1)
    end

    it "redirects to the email_historico_envios list" do
      email_historico_envio = EmailHistoricoEnvio.create! valid_attributes
      delete email_historico_envio_url(email_historico_envio)
      expect(response).to redirect_to(email_historico_envios_url)
    end
  end
end
