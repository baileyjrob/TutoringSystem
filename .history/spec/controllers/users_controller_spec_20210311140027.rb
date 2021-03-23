require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  describe "GET index" do
    it "assigns @users" do
      user = User.create
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it "renders the index view" do
      get :index
      expect(response).to render("index")
    end
  end

  #TODO: Implement others for posterity

  describe "GET show_schedule" do
    context "when user is signed in" do
      before do
        user = User.create
        tutoring_session_1 = TutoringSession.create
        tutoring_session_2 = TutoringSession.create
        tutoring_session_3 = TutoringSession.create
        user.tutoring_sessions << tutoring_session_1, tutoring_session_2, tutoring_session_3
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

class UsersController < ApplicationController
  #before_action :authenticate_user!
  def index  
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  def show_schedule
    if user_signed_in?
      @sessions = TutoringSession.joins(:users).where(users: { id: current_user.id})
    else
      redirect_to new_user_session_path
    end
  end

  private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :major, :email, :encrypted_password)
    end
end