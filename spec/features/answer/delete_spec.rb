require 'rails_helper'

describe 'only author can delete his answer', "
As an Autor,
I can only delete my answers
" do
  describe 'user tries delete an answer' do
    let(:author) { create(:user) }
    let(:author_question) { create(:question, user: author) }
    let!(:author_answer) { create(:answer, question: author_question, user: author) }

    context 'User is author', js: true do
      before { sign_in(author) }

      it 'author tries deleted your answer' do
        visit question_path(author_question)

        click_on 'Delete Answer'

        within '.answers' do
          expect(page).not_to have_content author_answer.body
        end
      end
    end

    context 'user is not author' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it "user tries deleted another user's question" do
        visit question_path(author_question)

        expect(page).not_to have_selector(:link_or_button, 'Delete Answer')
      end
    end
  end
end
