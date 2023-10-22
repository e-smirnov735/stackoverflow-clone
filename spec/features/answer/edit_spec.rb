require 'rails_helper'

describe 'User can edit his answer', "
In order to correct mistakes
As an author of answer
I'd like to be able to edit my answer
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question:, user:) }

  it 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    it 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    it 'edits his answer with errors', js: true do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end

    it 'edits his answer with add files', js: true do
      within '.answers' do
        fill_in 'Body', with: 'edit body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe "trie edit other user's answer" do
    let(:another_user) { create(:user) }

    before { sign_in(another_user) }

    it "tries edit other user's answer" do
      visit question_path(question)

      expect(page).not_to have_link 'Edit'
    end
  end
end
