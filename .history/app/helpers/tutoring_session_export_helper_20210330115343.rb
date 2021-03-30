# frozen_string_literal: true

require 'csv'

module TutoringSessionExportHelper
  def create_csv(start_date, end_date)
    file = Rails.root.join('public/tutoring_hours.csv')
    table = generate_query(start_date, end_date)
    headers = ['Tutor Name', 'Hours Worked']
    current_tutor = ''
    hours_worked = 0
    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      table.each do |entry|
        # Switch currently tracking tutor and print last one
        if current_tutor != entry.first_name
          writer << create_writer(entry) if current_tutor != ''
          current_tutor = entry.first_name
          hours_worked = 0
        end
        # Update hours_worked
        hours_worked += entry_duration(entry)
      end
    end
  end

  private

  def generate_query(start_date, end_date)
    User.joins('LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id')
        .where("(tutoring_sessions.session_status = 'Confirmed' \
                  OR tutoring_sessions.session_status = 'In-Person') AND \
                  tutoring_sessions.scheduled_datetime BETWEEN #{start_date} AND #{end_date}")
        .select("users.first_name,\
                  users.last_name,\
                  tutoring_sessions.scheduled_datetime,\
                  tutoring_sessions.complete_datetime")
  end

  def create_writer(entry)
    ["#{entry.first_name} #{entry.last_name}",
     hours_worked.to_s]
  end

  def entry_duration(entry)
    (entry.scheduled_datetime - entry.complete_datetime) / 1.hour
  end
end
