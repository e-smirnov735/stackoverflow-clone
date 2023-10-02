require 'rails_helper'

describe 'user can register in the system', '
As a user, I can register in the system to ask questions and answer them on my own behalf' do
  let(:user) { create(:user) }

  it 'unauthenticated user can register' do
    password = '12345678'

    visit new_user_registration_path

    fill_in 'Email', with: 'new_mail@mail.ru'
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  it 'authenticated user tries register' do
    # create user

    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
