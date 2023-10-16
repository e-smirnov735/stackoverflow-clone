class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show destroy update]
  before_action :set_question, only: %i[new create]
  before_action :set_answer, only: %i[show destroy update]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    question = @answer.question
    @answer.destroy

    redirect_to question_path(question), notice: 'The answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
