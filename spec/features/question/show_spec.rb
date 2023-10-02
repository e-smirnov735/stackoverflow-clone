require 'rails_helper'

describe 'user can view the question and the answers to it', "
As a user,
I can view the question and the answers to it in order
to get acquainted
" do
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question:) }

  it 'user can view the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end
end
