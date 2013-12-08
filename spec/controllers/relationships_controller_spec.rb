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
end