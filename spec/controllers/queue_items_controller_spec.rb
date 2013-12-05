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

  describe "POST create" do
    it "redirect to my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the sign in user" do
      marv = Fabricate(:user)
      session[:user_id] = marv.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(marv)
    end

    it "puts the video as the last one in the queue" do
      marv = Fabricate(:user)
      session[:user_id] = marv.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: marv)
      south_park = Fabricate(:video)
      post :create, video_id: south_park.id
      south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: marv.id).first
      expect(south_park_queue_item.position).to eq(2)
    end

    it "does not add the video the queue if the video is already in the queue" do
      marv = Fabricate(:user)
      session[:user_id] = marv.id
      monk = Fabricate(:video)
      Fabricate(:queue_item, video: monk, user: marv)
      post :create, video_id: monk.id
      expect(marv.queue_items.count).to eq(1)
    end
    it "redirects to the sign in page for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "DELETE destroy" do
    it "redirects to my queue page" do
      queue_item = Fabricate(:queue_item)
      session[:user_id] = Fabricate(:user).id
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      marv = Fabricate(:user)
      session[:user_id] = marv.id
      queue_item = Fabricate(:queue_item, user: marv)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      marv = Fabricate(:user)
      session[:user_id] = marv.id
      queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
      queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the item if the queue item is not in the current user's queue" do
      marv = Fabricate(:user)
      ace = Fabricate(:user)
      session[:user_id] = marv.id
      queue_item = Fabricate(:queue_item, user: ace)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects to the sign in page for unauthenticated users" do
      delete :destroy, id: 3
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirects to my queue page" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "reorders the queue items" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(marv.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(marv.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      it "redirects to my queue page" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        queue_item1 = Fabricate(:queue_item, user: marv, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to sign in path" do
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        marv = Fabricate(:user)
        session[:user_id] = marv.id
        ace = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: ace, position: 1)
        queue_item2 = Fabricate(:queue_item, user: marv, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
