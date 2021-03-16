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
      let!(:tutor) do
        User.new(first_name: 'Tutor', last_name: 'User', password: 'T3st!!a', email: 'tutor@tamu.edu')
      end
      let(:tutoring_session1) do
        TutoringSession.new(tutor_id: tutor.id, scheduled_datetime: '25 May 02:00:00 +0000'.to_datetime)
      end
      let(:tutoring_session2) do
        TutoringSession.new(tutor_id: tutor.id, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
      end
      let(:tutoring_session3) do
        TutoringSession.new(tutor_id: tutor.id, scheduled_datetime: '26 May 02:00:00 +0000'.to_datetime)
      end
      let(:user) do
        User.new(id: 2, first_name: 'Student', last_name: 'User', password: 'T3st!!a', email: 'student@tamu.edu')
      end

      #I've tried to figure out a way to do this via stubbing database access, but I just can't. Feel free to revise.
      before do
        tutor.save
        user.save
        tutoring_session1.save
        tutoring_session2.save
        tutoring_session3.save
        sign_in user
        user.tutoring_sessions << [tutoring_session1, tutoring_session2, tutoring_session3]
      end
      after do
        user.tutoring_sessions.destroy_all
      end
      it 'deletes' do
        delete_session_path(tutoring_session2)
        expect(controller.current_user.tutoring_sessions.reload).to eq([tutoring_session1, tutoring_session3])
      end
    end
  end
end
