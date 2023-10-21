require 'rails_helper'

RSpec.describe(QuestionsController, type: :controller) do
  let(:user) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question, user:) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3, user:) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to(match_array(questions))
    end

    it 'renders index view' do
      expect(response).to(render_template(:index))
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to(eq(question))
    end

    it 'assign new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to(render_template(:show))
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to(be_a_new(Question))
    end

    it 'render new view' do
      expect(response).to(render_template(:new))
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect do
          post(:create, params: { question: attributes_for(:question) })
        end.to(change(Question, :count).by(1))
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to(redirect_to(assigns(:question)))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post(:create, params: { question: attributes_for(:question, :invalid) })
        end
          .not_to(change(Question, :count))
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to(render_template(:new))
      end
    end
  end

  describe 'GET #delete' do
    describe 'user is author' do
      let!(:question) { create(:question, user:) }

      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    describe 'user is not author' do
      let!(:question) { create(:question, user:) }

      before { login(not_author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assign the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question to updated question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:question) { create(:question, :freeze, user:) }

      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyTitle'
        expect(question.body).to eq 'MyBody'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'user is not author' do
      it 'changes question to updated question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end
end
