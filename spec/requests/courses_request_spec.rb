require 'rails_helper'

RSpec.describe "Courses", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/courses/new"
      expect(response).to have_http_status(:success)
    end
  end

<<<<<<< Updated upstream
  describe "GET /edit" do
    it "returns http success" do
      get "/courses/edit"
=======
  describe "GET /index" do
    it "returns http success" do
      get "/courses/index"
>>>>>>> Stashed changes
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/courses/show"
      expect(response).to have_http_status(:success)
    end
  end

<<<<<<< Updated upstream
  describe "GET /index" do
    it "returns http success" do
      get "/courses/index"
=======
  describe "GET /edit" do
    it "returns http success" do
      get "/courses/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/courses/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/courses/delete"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/courses/destroy"
>>>>>>> Stashed changes
      expect(response).to have_http_status(:success)
    end
  end

end
