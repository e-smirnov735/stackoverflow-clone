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
            answer: attributes_for(:answer, user_id: user)
          }
        end
          .to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, user_id: user)
        }
        expect(response).to redirect_to question
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

        expect(response).to redirect_to(assigns(:question))
      end
    end
  end

  describe 'GET #delete' do
    before { login(user) }

    let!(:question) { create(:question, user:) }
    let!(:answer) { create(:answer, question:) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }

      expect(response).to redirect_to question_path(question)
    end
  end
end
