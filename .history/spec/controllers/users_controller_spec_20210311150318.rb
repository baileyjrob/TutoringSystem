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

  #TODO: Implement others for posterity

  describe "GET show_schedule" do
    context "when user is signed in" do
      before do
        user = User.create
        allow(user).to receive(:tutoring_sessions)
        allow(user).to receive(:tutoring_sessions<<(*records))
        tutoring_session_1 = TutoringSession.create
        tutoring_session_2 = TutoringSession.create
        tutoring_session_3 = TutoringSession.create
        user.tutoring_sessions << [tutoring_session_1, tutoring_session_2, tutoring_session_3]
        sign_in
      end
      it "assigns @sessions" do
        get :show_schedule
        expect(assigns(:shedules)).to eq([tutoring_session_1, tutoring_session_2, tutoring_session_3])
      end
      it "renders the schedule viewer" do
        get :show_schedule
        expect(response).to render("show_schedule")
      end
    end
    context "when no user is signed in" do
      before do
        sign_in nil
      end
      it "redirects to sign in" do
        get :show_schedule
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end