# frozen_string_literal: true

require 'csv'

module TutoringSessionExportHelper
  private:

  public:
  def create_csv(start_date, end_date)
    file = Rails.root.join('public/tutoring_hours.csv')
    table = User.joins('LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id')
                .where("(tutoring_sessions.session_status = 'Confirmed' \
                  OR tutoring_sessions.session_status = 'In-Person') AND \
                  tutoring_sessions.scheduled_datetime BETWEEN #{start_date} AND #{end_date}")
                .select("users.first_name,\
                  users.last_name,\
                  tutoring_sessions.scheduled_datetime,\
                  tutoring_sessions.complete_datetime")
    headers = ['Tutor Name', 'Hours Worked']
    current_tutor = ''
    hours_worked = 0
    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      table.each do |entry|
        # Switch currently tracking tutor and print last one
        if current_tutor != entry.first_name
          if current_tutor != ''
            writer << ["#{entry.first_name} #{entry.last_name}",
                       hours_worked.to_s]
          end
          current_tutor = entry.first_name
          hours_worked = 0
        end
        # Update hours_worked
        hours_worked += (entry.scheduled_datetime - entry.complete_datetime) / 1.hour
      end
    end
  end
end
