require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      marv = Fabricate(:user)
      marv.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end

    it "sets @token" do
      marv = Fabricate(:user)
      marv.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end


    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create do" do
    context "with valid token" do
      it "redirects to the sign in page" do
        marv = Fabricate(:user, password: 'old_password')
        marv.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end

      it "update the user's password" do
        marv = Fabricate(:user, password: 'old_password')
        marv.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(marv.reload.authenticate('new_password')).to be_true
      end

      it "sets the flash success message" do
        marv = Fabricate(:user, password: 'old_password')
        marv.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(flash[:success]).to be_present
      end

      it "regenerates the user token" do
        marv = Fabricate(:user, password: 'old_password')
        marv.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
        expect(marv.reload.token).not_to eq('12345')
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end