class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update edit update_best_answer]
  before_action :user_author?, only: %i[destroy update edit update_best_answer]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id

    if @question.save
      redirect_to @question, notice: 'Your question successfuly created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Your question successfuly updated'
    else
      render :edit, alert: 'errors'
    end
  end

  def update_best_answer
    @question.update(question_params)
  end

  def destroy
    @question.destroy

    redirect_to questions_path, notice: 'The question was successfully deleted'
  end

  private

  def user_author?
    redirect_to @question, alert: 'forbidden action' unless @question.author?(current_user)
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
