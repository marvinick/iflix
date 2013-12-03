require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      marv = Fabricate(:user)
      session[:user_id] = marv.id
      queue_item1 = Fabricate(:queue_item, user: marv)
      queue_item2 = Fabricate(:queue_item, user: marv)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end
end