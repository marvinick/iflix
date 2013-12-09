require 'spec_helper'

feature 'User following' do
  scenario "user follows and unfollows someone" do

    marv = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: marv, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link marv.full_name
    click_link "Follow"
    expect(page).to have_content(marv.full_name)

    unfollow(marv)
    expect(page).not_to have_content(marv.full_name)

end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end