class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def author?(current_user)
    user == current_user
  end
end
