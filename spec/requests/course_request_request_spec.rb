# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CourseRequests', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/course_request/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /request' do
    it 'returns http success' do
      get '/course_request/request'
      expect(response).to have_http_status(:success)
    end
  end
end
