require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      marv = Fabricate(:user)
      set_current_user(marv)
      ace = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: marv, leader: ace)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end

    it "redirects to the people page" do
      marv = Fabricate(:user)
      set_current_user(marv)
      ace = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: marv, leader: ace)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationships if the current userr is not the follower" do
      marv = Fabricate(:user)
      set_current_user(marv)
      ace = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: marv, leader: ace)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      marv = Fabricate(:user)
      set_current_user(marv)
      ace = Fabricate(:user)
      david = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: david, leader: ace)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 3 }
    end
  end

  it "redirects to the people page" do
    marv = Fabricate(:user)
    ace = Fabricate(:user)
    set_current_user(marv)
    post :create, leader_id: ace.id
    expect(response).to redirect_to people_path
  end

  it "creates a relationship that the current user follows the leader" do
    marv = Fabricate(:user)
    ace = Fabricate(:user)
    set_current_user(marv)
    post :create, leader_id: ace.id
    expect(marv.following_relationships.first.leader).to eq(ace)
  end

  it "does not create a relationship if the current user already follow the leader" do
    marv = Fabricate(:user)
    ace = Fabricate(:user)
    set_current_user(marv)
    Fabricate(:relationship, leader: ace, follower: marv)
    post :create, leader_id: ace.id
    expect(Relationship.count).to eq(1)
  end

  it "does not allow one to follow themselves" do
    marv = Fabricate(:user)
    set_current_user(marv)
    post :create, leader_id: marv.id
    expect(Relationship.count).to eq(0)
  end
end