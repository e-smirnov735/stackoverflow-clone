require 'rails_helper'

describe 'user can give an answer on question page', "
I, as a user,
can give an answer on the question page in order
to help another user
" do
  let(:question) { create(:question) }

  it 'is a form on the page to create a response' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_selector(:link_or_button, 'Post Your Answer')
  end
end
