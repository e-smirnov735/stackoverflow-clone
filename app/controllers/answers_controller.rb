class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show destroy update]
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy update update_favorite]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    return unless @answer.author?(current_user)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    return unless @answer.author?(current_user)

    @question = @answer.question
    @answer.destroy
  end

  def update_favorite
    return unless @answer.question.author?(current_user)

    @answer.update_favorite
    @answers = @answer.question.answers.sort_by_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id, files: [])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
