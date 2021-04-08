# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TutoringSessionExportHelper, type: :helper do
  let!(:tutor) do
    User.create(
      first_name: 'Tutor',
      last_name: 'User',
      password: 'T3st!!a',
      email: 'tutor@tamu.edu'
    )
  end
  let(:tutoring_sessions) {[TutoringSession.create()]}
end
