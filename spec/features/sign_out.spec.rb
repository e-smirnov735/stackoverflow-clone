require 'rails_helper'

describe 'User can sign out', "
  In order to leave website
  As authenticated user
  I'd like to be able to sign out
" do
  let(:user) { create(:user) }

  before { sign_in(user) }

  it 'Registered user tries to sign in' do
    click_on 'Exit'

    expect(page).to have_content 'Signed out successfully.'
  end
end
