require 'rails_helper'

describe 'User can create answer for question', "
  As an authenticated user
  I'd like to be able to create a answer for current question
" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit question_path(question)
    end

    it 'asks an answer' do
      fill_in 'Body', with: 'My answer'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Your answer successfuly created.'
      expect(page).to have_content 'My answer'
    end
  end

  it 'Unauthenticated user tries to create an answer' do
    visit question_path(question)
    fill_in 'Body', with: 'My answer'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
