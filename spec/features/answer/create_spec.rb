require 'rails_helper'

describe 'User can create answer for question', "
  As an authenticated user
  I'd like to be able to create a answer for current question
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, user:) }

  describe 'Authenticated user' do
    before do
      sign_in(user)

      visit question_path(question)
    end

    it 'asks an answer', js: true do
      fill_in 'Body', with: 'My answer TEST'
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_content 'My answer TEST'
      end
    end

    it 'asks a answer with attached file', js: true do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'create answer with errors', js: true do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  it 'Unauthenticated user tries to create an answer' do
    visit question_path(question)
    fill_in 'Body', with: 'My answer'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
