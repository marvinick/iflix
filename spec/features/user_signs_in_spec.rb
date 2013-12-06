require 'spec_helper'

feature 'user signs in' do

  scenario "with valid user email and password" do
    marv = Fabricate(:user)
    visit sign_in_path
    fill_in "Email Address", with: marv.email
    fill_in "Password", with: marv.password
    click_button "Sign in"
    page.should have_content marv.full_name
  end
end