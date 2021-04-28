# frozen_string_literal: true

require 'csv'

module TutoringSessionExportHelper
  def acquire_hours(start_date, end_date, filepath = 'public/tutoring_hours.csv')
    create_csv(start_date, end_date, filepath)
    mail_csv(start_date, end_date, filepath)
  end

  def create_csv(start_date, end_date, filepath = 'public/tutoring_hours.csv')
    file = Rails.root.join(filepath)
    table = generate_query(start_date, end_date)
    headers = %w[Tutor_Name Hours_Worked]
    write_to_csv(file, table, headers)
  end

  def mail_csv(start_date, end_date, filepath)
    if Rails.env.test?
      HourCheckMailer.hours_email(start_date, end_date, filepath,
                                  'admin@tamu.edu').deliver_now
    else
      HourCheckMailer.hours_email(start_date, end_date,
                                  filepath, current_user.email).deliver_later
    end
  end

  private

  def generate_query(start_date, end_date)
    User.joins(:roles, 'LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id')
        .where("(tutoring_sessions.session_status = 'Confirmed' \
                  OR tutoring_sessions.session_status = 'In-Person' OR \
                  tutoring_sessions.session_status IS NULL) AND roles.role_name = 'Tutor' AND \
                  (scheduled_datetime BETWEEN ? AND ? OR scheduled_datetime IS NULL)",
               start_date, end_date)
        .select("users.first_name,\
                  users.last_name,\
                  tutoring_sessions.scheduled_datetime,\
                  tutoring_sessions.completed_datetime")
  end

  # Simply returns the full name of a tutor in table entry
  def full_name(entry)
    "#{entry.first_name} #{entry.last_name}"
  end

  # Returns how long a tutoring session lasted
  def entry_duration(entry)
    if !entry.completed_datetime.nil?
      (entry.completed_datetime - entry.scheduled_datetime) / 1.hour
    else
      0.0
    end
  end

  # Handles the legwork of writing to CSV
  # (hours_worked and current_tutor are only parameters to save on linenum and shouldn't be passed)
  def write_to_csv(file, table, headers)
    hours_worked = 0
    current_tutor = ''
    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
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
    # Output final user
    writer << [current_tutor, hours_worked.to_s] if current_tutor != ''
  end
end
