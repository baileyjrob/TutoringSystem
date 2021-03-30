# frozen_string_literal: true

require 'csv'

module TutoringSessionExportHelper
  def create_csv(start_date, end_date, filepath = 'public/tutoring_hours.csv')
    file = Rails.root.join(filepath)
    table = generate_query(start_date, end_date)
    headers = ["Tutor Name", "Hours Worked"]
    write_to_csv(file, table, headers)
  end

  private

  def generate_query(start_date, end_date)
    User.joins('LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id')
        .where("(tutoring_sessions.session_status = 'Confirmed' \
                  OR tutoring_sessions.session_status = 'In-Person') AND \
                  tutoring_sessions.scheduled_datetime BETWEEN #{start_date.to_s} AND #{end_date.to_s}")
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

  # Handles the legwork of writing to CSV
  # (hours_worked and current_tutor are only parameters to save on linenum and shouldn't be passed)
  def write_to_csv(file, table, headers)
    hours_worked = 0
    current_tutor = ''
    CSV.open(file, 'w', headers: headers) do |writer|
      table_iterate(table, writer, hours_worked, current_tutor)
    end
  end

  def table_iterate(table, writer, hours_worked = 0, current_tutor = '')
    table.each do |entry|
      # Switch currently tracking tutor and print last one
      if current_tutor != full_name(entry)
        writer << [current_tutor, hours_worked.to_s] if current_tutor != ''
        current_tutor = full_name(entry)
        hours_worked = 0
      end
      # Update hours_worked
      hours_worked += entry_duration(entry)
    end
  end
end
