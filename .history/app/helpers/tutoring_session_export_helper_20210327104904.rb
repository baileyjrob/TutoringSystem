# frozen_string_literal: true

require 'csv'
file = Rails.root.join('public/tutoring_hours.csv')
table = User.joins('LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id')
            .where("tutoring_sessions.session_status = 'Confirmed' \
              OR tutoring_sessions.session_status = 'In-Person'")
            .select('users.first_name,\
              users.last_name,\
              tutoring_sessions.scheduled_datetime,\
              tutoring_sessions.complete_datetime')
headers = ['Tutor Name', 'Hours Worked']
current_tutor = ''
hours_worked = 0
CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
  table.each do |entry|
    # Switch currently tracking tutor and print last one
    if current_tutor != entry.first_name
      writer << ["#{entry.first_name} #{entry.last_name}", hours_worked.to_s] if current_tutor != ''
      current_tutor = entry.first_name
      hours_worked = 0
    end
    # Update hours_worked
    hours_worked += (entry.scheduled_datetime - entry.complete_datetime) / 1.hour
  end
end
