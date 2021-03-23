# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  # describe "GET index" do
  #   it "assigns @users" do
  #     user = User.create
  #     get :index
  #     expect(assigns(:users)).to eq([user])
  #   end

  #   it "renders the index view" do
  #     get :index
  #     expect(response).to render("index")
  #   end
  # end

  # TODO: Implement others for posterity

  describe 'GET show_schedule' do
    context 'when user is signed in' do
      let(:tutoring_session1) { TutoringSession.create }
      let(:tutoring_session2) { TutoringSession.create }
      let(:tutoring_session3) { TutoringSession.create }
      let(:user) { User.create }

      before do
        allow(user).to receive(:tutoring_sessions).and_call_original
        user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]
        sign_in user
      end

      it 'assigns @sessions' do
        get :show_schedule
        expect(controller.view_assigns['sessions']).to eq([tutoring_session1,
                                                           tutoring_session2, tutoring_session3])
      end
    end

    context 'when no user is signed in' do
      before do
        sign_in nil
      end

      it 'redirects to sign in' do
        get :show_schedule
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST delete_schedule' do
    context 'when user is signed in' do
      let(:tutoring_session1) do
        TutoringSession.new(id: 1, tutor_id: 1, scheduled_datetime: '25 May 02:00:00 +0000'.to_datetime)
      end
      let(:tutoring_session2) do
        TutoringSession.new(id: 2, tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
      end
      let(:tutoring_session3) do
        TutoringSession.new(id: 3, tutor_id: 1, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
      end
      let(:user) { User.create }

      before do
        allow(user).to receive(:tutoring_sessions).and_call_original
        allow(TutoringSession).to receive(:find).with(1) {tutoring_session1}
        allow(TutoringSession).to receive(:find).with(2) {tutoring_session2}
        allow(TutoringSession).to receive(:find).with(3) {tutoring_session3}
        sign_in user
        user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]
      end
      it 'assigns tutor_session' do
        delete_session_path(tutoring_session2)
        expect(controller.view_assigns['tutor_session']).to eq(tutoring_session2)
      end
      it 'deletes' do
        delete_session_path(tutoring_session2)
        expect(user.tutoring_sessions).to eq([tutoring_session1, tutoring_session3])
      end
      it 'does not delete the session object' do
        delete_session_path(tutoring_session2)
        expect(tutoring_session3).to exist
      end
    end
  end
end
