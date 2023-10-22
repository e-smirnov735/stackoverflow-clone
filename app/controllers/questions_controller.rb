class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update edit update_best_answer]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.sort_by_best
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
    return unless @question.author?(current_user)

    if @question.update(question_params)
      redirect_to @question, notice: 'Your question successfuly updated'
    else
      render :edit, alert: 'errors'
    end
  end

  def destroy
    return unless @question.author?(current_user)

    @question.destroy

    redirect_to questions_path, notice: 'The question was successfully deleted'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
