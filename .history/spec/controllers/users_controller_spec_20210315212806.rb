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
        TutoringSession.new(tutor_id: tutor.id,
                            scheduled_datetime: '25 May 02:00:00 +0000'.to_datetime)
      end
      let(:tutoring_session2) do
        TutoringSession.new(tutor_id: tutor.id,
                            scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
      end
      let(:tutoring_session3) do
        TutoringSession.new(tutor_id: tutor.id,
                            scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
      end
      let!(:user) do
        User.new(first_name: 'Student', last_name: 'User', password: 'T3st!!a',
                 email: 'student@tamu.edu')
      end

      # Tried to figure out a way to do this via stubbing database access, but can't. Revise.
      before do
        user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]
        allow(tutoring_session2).to receive(:id).and_return(2)
        allow(user).to receive(:id).and_return(0)
        allow(User).to receive(:find).with(0) { user }
        allow(TutoringSession).to receive(:find).with('2') { tutoring_session2 }
        sign_in user
      end

      it 'deletes' do
        post :delete_session, params: { id: tutoring_session2.id }
        expect(user.tutoring_sessions).to eq([tutoring_session1, tutoring_session3])
      end
    end
  end
end
