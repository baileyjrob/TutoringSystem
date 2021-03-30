# frozen_string_literal: true

require 'csv'

module TutoringSessionExportHelper
  def create_csv(start_date, end_date)
    file = Rails.root.join('public/tutoring_hours.csv')
    table = generate_query(start_date, end_date)
    headers = ['Tutor Name', 'Hours Worked']
    write_to_csv(file, table, headers)
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

  # Simply returns the full name of a tutor in table entry
  def full_name(entry)
    "#{entry.first_name} #{entry.last_name}"
  end

  # Returns how long a tutoring session lasted
  def entry_duration(entry)
    (entry.scheduled_datetime - entry.complete_datetime) / 1.hour
  end

  # Switches to a new tutor (and writes the old to csv) when a change is detected
  def change_tutor(writer, hours_worked, entry, current_tutor)
    writer << [current_tutor, hours_worked.to_s] if current_tutor != ''
    full_name(entry)
  end

  # Handles the legwork of writing to CSV
  def write_to_csv(file, table, headers)
    hours_worked = 0
    current_tutor = ''
    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      table.each do |entry|
        # Switch currently tracking tutor and print last one
        if current_tutor != full_name(entry)
          current_tutor = change_tutor(writer, hours_worked, entry, current_tutor)
          hours_worked = 0
        end
        # Update hours_worked
        hours_worked += entry_duration(entry)
      end
    end
  end
end
