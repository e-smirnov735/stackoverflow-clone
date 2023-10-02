require 'rails_helper'

describe 'User can views  all questions', "
As a user, I can view a list of all the
questions in order to help someone
" do
  describe 'User can view a list of all the question' do
    let!(:questions) { create_list(:question, 5) }
    let(:user) { create(:user) }

    it 'Unauthenticated user' do
      visit questions_path

      expect(page).to have_content questions.first.title
      expect(page).to have_content questions.last.title
    end

    it 'Authenticated user' do
      sign_in(user)

      visit questions_path

      expect(page).to have_content questions.first.title
      expect(page).to have_content questions.last.title
    end
  end
end
