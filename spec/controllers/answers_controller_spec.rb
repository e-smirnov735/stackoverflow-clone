require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question:) }
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { get :show, params: { question_id: question, id: answer } }

    it 'assign the requested question to @question' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)

      get :new, params: {
        question_id: question,
        answer: attributes_for(:answer)
      }
    end

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }
        end
          .to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer)
        }
        expect(response).to redirect_to(assigns(:answer))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid)
          }
        end
          .not_to change(question.answers, :count)
      end

      it 're-render new view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, :invalid)
        }

        expect(response).to render_template :new
      end
    end
  end
end
