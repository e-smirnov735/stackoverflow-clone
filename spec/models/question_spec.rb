require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
end
