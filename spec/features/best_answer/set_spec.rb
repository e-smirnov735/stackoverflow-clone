require 'rails_helper'

describe 'Author can set best answer fo his question' do
  let!(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:answers) { create_list(:answer, 3, question:) }

  it 'unauthenticated user tries set best answer'
  it 'authinticated user tries set best answer'

  it 'an autor set answer', js: true do
    sign_in(author)
    visit question_path(question)

    within "#answerId-#{answers.first.id}" do
      click_on 'Set best'
      expect(page).to have_selector '.favorite'
    end
  end
end
