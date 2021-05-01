# frozen_string_literal: true

require 'csv'

module SpartanSessionExportHelper
  extend self

  def create_csv(session_id, time, filepath =
        "public/spartan_attendance_#{time}.csv")
    file = Rails.root.join(filepath)
    users = SpartanSession.find(session_id).users
    headers = %w[First_Name Last_Name Email MU Outfit Check_In Check_Out Time_In_Session
                 Attendance_Notes]
    write_to_csv(file, users, session_id, headers)
  end

  private

  def find_duration(first, second)
    if first.nil? || second.nil?
      0.0
    else
      (second - first) / 60.0
    end
  end

  def get_time(time)
    if time.nil?
      'N/A'
    else
      time.strftime('%m/%d/%Y %T')
    end
  end

  def write_to_csv(file, users, session_id, headers)
    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      table_iterate(users, session_id, writer)
    end
  end

  def table_iterate(users, session_id, writer)
    users.each do |user|
      # Fill in headers
      session_user = SpartanSessionUser.find_by(spartan_session_id: session_id, user_id: user.id)

      # Write to csv
      setup_writer(user, session_user, session_user.attendance, writer)
    end
  end

  def setup_writer(user, sess_user, attendance, writer)
    # Get arguments
    time = find_duration(sess_user.first_checkin, sess_user.second_checkin)
    first = get_time(sess_user.first_checkin)
    second = get_time(sess_user.second_checkin)

    # Need to add arguments to writer
    fill_writer(writer, [user.first_name, user.last_name, user.email, user.mu, user.outfit, first,
                         second, time, attendance])
  end

  def fill_writer(writer, args)
    writer << args
  end
end
