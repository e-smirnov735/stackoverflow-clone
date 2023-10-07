require 'rails_helper'

describe 'only author can delete his question', "
As an Autor,
I can only delete my question
" do
  let(:author) { create(:user) }
  let(:author_question) { create(:question, user: author) }

  describe 'user tries delete a question' do
    context 'user is author' do
      before { sign_in(author) }

      it 'author tries deleted his question' do
        visit question_path(author_question)

        click_on 'Delete'
        expect(page).to have_content 'The question was successfully deleted'
      end
    end

    context 'user is not author' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'user is not author' do
        visit question_path(author_question)

        expect(page).to have_content author_question.title
        expect(page).not_to have_selector(:link_or_button, 'Delete')
      end
    end
  end
end
