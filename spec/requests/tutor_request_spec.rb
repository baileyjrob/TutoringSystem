require 'rails_helper'

RSpec.describe "Tutors", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/tutor/index"
      expect(response).to have_http_status(:success)
    end
  end

end
