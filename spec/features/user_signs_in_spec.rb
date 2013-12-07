require 'spec_helper'

feature 'user signs in' do

  scenario "with valid user email and password" do
    marv = Fabricate(:user)
    sign_in(marv)
    page.should have_content marv.full_name
  end
end