require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }

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
                        },
                        format: :js
        end
          .to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: {
                        question_id: question,
                        answer: attributes_for(:answer, user_id: user)
                      },
                      format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
                          question_id: question,
                          answer: attributes_for(:answer, :invalid)
                        },
                        format: :js
        end
          .not_to change(question.answers, :count)
      end

      it 'renders question show view' do
        post :create, params: {
                        question_id: question,
                        answer: attributes_for(:answer, :invalid)
                      },
                      format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'GET #delete' do
    before { login(user) }

    let!(:question) { create(:question, user:) }
    let!(:answer) { create(:answer, question:, user:) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: answer }, format: :js

      expect(response).to render_template :destroy
    end

    context 'user is not autor' do
      let!(:not_author) { create(:user) }

      before { login(not_author) }

      it 'user tries delete another answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalide attributes' do
      it 'does bot change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'user is not autor' do
      let!(:not_author) { create(:user) }

      before { login(not_author) }

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).not_to eq 'new body'
      end
    end
  end

  describe 'PATCH #update_favorite' do
    context 'user is author for current question question' do
      before { login(user) }

      it 'change best answer' do
        patch :update_favorite, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end

      it 'other questions is no best' do
        patch :update_favorite, params: { id: answer }, format: :js
        answer.reload
        expect(answer.question.answers.where(best: true).count).to eq 1
      end
    end

    context 'user is not author for current question' do
      let!(:not_author) { create(:user) }

      before { login(not_author) }

      it 'not changes best answer' do
        expect do
          patch :update, params: { id: answer }, format: :js
        end.not_to change(answer, :best)
      end
    end
  end
end
