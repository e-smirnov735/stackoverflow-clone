require 'rails_helper'

describe 'User can edit his question', "
In order to correct mistakes
As an author of answer
I'd like to be able to edit my question
" do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user:) }

  it 'Unauthenticated user can not edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it 'edits his question', js: true do
      click_on 'Edit'

      fill_in 'Body', with: 'edited question body'
      fill_in 'Title', with: 'edited question title'
      click_on 'Save'

      expect(page).not_to have_content question.body
      expect(page).to have_content 'Your question successfuly updated'
      expect(page).to have_content 'edited question body'
      expect(page).to have_content 'edited question title'
    end

    it 'edits his question with errors', js: true do
      click_on 'Edit'

      fill_in 'Body', with: ''
      fill_in 'Title', with: ''
      click_on 'Save'

      expect(page).to have_selector 'textarea'
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
    end

    it 'edits his question with add files' do
      click_on 'Edit'

      fill_in 'Body', with: 'edit body'
      fill_in 'Title', with: 'edit text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe "trie edit other user's question" do
    let(:another_user) { create(:user) }

    before { sign_in(another_user) }

    it "tries edit other user's answer" do
      visit question_path(question)

      within '.question' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
