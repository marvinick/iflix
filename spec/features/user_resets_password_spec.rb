require 'spec_helper'

feature 'User resets password' do
  scenario 'user succesfully resets the password' do
    marv = Fabricate(:user, password: 'no_mas_password')
    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: marv.email
    click_button "Send Email"

    open_email(marv.email)
    current_email.click_link("Reset My Password")

    fill_in "New Password", with: "mas_password"
    click_button "Reset Password"

    fill_in "Email Address", with: marv.email
    fill_in "Password", with: "mas_password"
    click_button "Sign in"
    expect(page).to have_content("Welcome, #{marv.full_name}")

    clear_email
  end
end