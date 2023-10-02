class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show new create inline_create]

  def show
    @answer = @question.answers.find(params[:id])
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_param)

    if @answer.save
      redirect_to @answer
    else
      render :new
    end
  end

  def inline_create
    @answer = @question.answers.new(answer_param)

    if @answer.save
      redirect_to @question, notice: 'Your answer successfuly created.'
    else
      render_to @question, alert: 'NOT CREATE'
    end
  end

  private

  def answer_param
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
