require 'rails_helper'

RSpec.describe(QuestionsController, type: :controller) do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

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
    before { login(user) }

    let!(:question) { create(:question, user:) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }

      expect(response).to redirect_to questions_path
    end
  end
end
