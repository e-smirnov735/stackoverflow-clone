class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_param)

    if @question.save
      redirect_to @question, notice: 'Your question successfuly created.'
    else
      render :new
    end
  end

  private

  def question_param
    params.require(:question).permit(:title, :body)
  end
end
