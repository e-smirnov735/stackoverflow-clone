# class Answer
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def author?(current_user)
    user == current_user
  end

  def update_favorite
    transaction do
      self.class.where(question_id:).update_all(best: false)
      update(best: true)
    end
  end
end
