require 'rails_helper'

describe 'only author can delete attached file from question and answer', "
As an Autor,
I can  delete attached file from  my answer or question
" do
  let(:author) { create(:user) }
  let(:question) { create(:question, :with_file, user: author) }
  let!(:answer) { create(:answer, :with_files, question:, user: author) }

  context 'user is author' do
    before do
      sign_in(author)
      visit question_path(question)
    end

    it 'author can delete attached file from his question' do
      click_on 'Edit', match: :first
      click_on 'Delete file'

      expect(page).not_to have_link 'rails_helper.rb'
    end

    it 'author can delete attached file from his asnwer' do
      within "#answerId-#{answer.id}" do
        click_on 'Edit'
        click_on 'Delete file', match: :first

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end
  end

  context 'user is not author' do
    before { visit question_path(question) }

    it 'user can not delete file from another question or answer' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
