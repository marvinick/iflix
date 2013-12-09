require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items) }
  it { should have_many(:reviews) }

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_true
    end

    it "returns false when the user has not queued the video" do

      user = Fabricate(:user)
      video = Fabricate(:video)
      user.queued_video?(video).should be_false
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      marv = Fabricate(:user)
      ace = Fabricate(:user)
      Fabricate(:relationship, leader: ace, follower: marv)
      expect(marv.follows?(ace)).to be_true
    end
    it " returns false if the user does not have a following relationship with another user" do
      marv = Fabricate(:user)
      ace = Fabricate(:user)
      Fabricate(:relationship, leader: marv, follower: ace)
      expect(marv.follows?(ace)).to be_false
    end
  end
end