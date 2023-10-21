require 'rails_helper'

describe 'Author can set best answer fo his question' do
  let!(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:answers) { create_list(:answer, 3, question:) }

  context 'user is not_author for current question' do
    context 'authenticated user' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'authenticated user tries set best answer' do
        visit question_path(question)

        expect(page).not_to have_selector '.best-answer-btn'
      end
    end

    it 'unauthinticated user tries set best answer' do
      visit question_path(question)

      expect(page).not_to have_selector '.best-answer-btn'
    end
  end

  context 'user is author' do
    before { sign_in(author) }

    it 'an autor set answer', js: true do
      visit question_path(question)

      within "#answerId-#{answers.first.id}" do
        click_on 'Set best'
        expect(page).to have_selector '.favorite'
      end
    end
  end
end
