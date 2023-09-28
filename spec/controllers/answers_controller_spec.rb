require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #show' do
    it 'assign the requested question to @question' do
    end
    it 'render show view' do
    end
  end

  describe 'GET #new' do
    it 'assigns a new Answer to @answer' do
    end

    it 'render new view' do
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
      end
      it 'redirect to show view' do
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
      end
      it 're-render new view' do
      end
    end
  end
end
