require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #purge' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, :with_file, user: author) }
    let(:answer) { create(:answer, :with_files, user: author) }

    context 'user is autor' do
      before { login(author) }

      it 'author can delete attachment from question' do
        expect do
          delete :purge, params: { id: question.files_attachments.first }
        end.to change(question.files, :count).by(-1)
      end

      it 'author can delete attachments from answer' do
        expect do
          delete :purge, params: { id: answer.files_attachments.last }
        end.to change(answer.files, :count).by(-1)
      end

      context 'user is not author' do
        let(:user) { create(:user) }

        before { login(user) }

        it "user can't delete attachment from question" do
          expect do
            delete :purge, params: { id: question.files_attachments.first }
          end.not_to change(question.files, :count)
        end

        it "user can't delete attachment from answer" do
          expect do
            delete :purge, params: { id: answer.files_attachments.last }
          end.not_to change(answer.files, :count)
        end
      end
    end
  end
end
