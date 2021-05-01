# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpartanSessionExportHelper, type: :helper do
  # TODO
  filepath = 'spec/helpers/spartan_session_spec'
  let(:attended_student) do
    User.create(
      first_name: 'John',
      last_name: 'Smith',
      password: 'asdasd',
      outfit: 'Alpha',
      mu: '2',
      email: 'john@tamu.edu'
    )
  end
  let(:added_student) do
    User.create(
      first_name: 'Jane',
      last_name: 'Doe',
      password: 'asdasd',
      outfit: 'Alpha',
      mu: '2',
      email: 'jane@tamu.edu'
    )
  end
  let(:spartan_session) do
    SpartanSession.create(
      session_datetime: Time.zone.now,
      first_code: 'asdasd',
      second_code: '123123'
    )
  end
  let(:user_first_checkin) { Time.zone.now + 60 }
  let(:user_second_checkin) { Time.zone.now + 600 }

  context 'when csv is requested' do
    before do
      # Add users to session
      spartan_session.users << attended_student
      SpartanSessionUser.find_by(spartan_session_id: spartan_session.id,
                                 user_id: attended_student.id)
                        .update(first_checkin: user_first_checkin,
                                second_checkin: user_second_checkin)

      spartan_session.users << added_student
      SpartanSessionUser.find_by(spartan_session_id: spartan_session.id,
                                 user_id: added_student.id)
                        .update(attendance: 'TEST')

      # Create CSV file
      create_csv(spartan_session.id, '', "#{filepath}.csv")
    end

    it 'generates a csv for someone who checked in and out with no notes' do
      csv_table = CSV.read(Rails.root.join("#{filepath}.csv"), headers: true)
      expect([csv_table[0]['First_Name'], csv_table[0]['Last_Name'], csv_table[0]['Email'],
              csv_table[0]['Outfit'], csv_table[0]['MU'],
              csv_table[0]['Check_In'], csv_table[0]['Check_Out'],
              csv_table[0]['Attendance_Notes']]).to eq ['John', 'Smith', 'john@tamu.edu', 'Alpha',
                                                        '2',
                                                        user_first_checkin.strftime('%m/%d/%Y %T'),
                                                        user_second_checkin.strftime('%m/%d/%Y %T'),
                                                        nil]
    end

    it 'generates a csv with time difference for someone who checked in and out' do
      csv_table = CSV.read(Rails.root.join("#{filepath}.csv"), headers: true)
      expect(csv_table[0]['Time_In_Session']).not_to be('0.0')
    end

    it 'generates a csv for someone who was added to the attendance list via notes' do
      csv_table = CSV.read(Rails.root.join("#{filepath}.csv"), headers: true)
      expect([csv_table[1]['First_Name'], csv_table[1]['Last_Name'], csv_table[1]['Email'],
              csv_table[0]['Outfit'], csv_table[0]['MU'],
              csv_table[1]['Check_In'], csv_table[1]['Check_Out'], csv_table[1]['Time_In_Session'],
              csv_table[1]['Attendance_Notes']]).to eq %w[Jane Doe jane@tamu.edu Alpha 2 N/A N/A
                                                          0.0 TEST]
    end
  end
end
