# frozen_string_literal: true

require 'tutoring_session_export_helper'
module AdminViewHoursHelper
  include TutoringSessionExportHelper

  # Guards against unauthorized access
  def admin_view_hours_prep
    return if current_user.roles.include?(Role.admin_role)

    redirect_to root_path
  end

  # Handles the legwork and sets off into the helper-function proper
  def admin_view_hours_exec(params)
    return -1 if params[:start_time].nil? || params[:end_time].nil?

    start_date = synthesize_start_date(params)
    end_date = synthesize_end_date(params)

    return unless current_user.roles.include?(Role.admin_role)

    return if start_date > end_date

    acquire_hours(start_date, end_date)
  end

  # Takes the horrible-looking form output and formats to Date
  def synthesize_start_date(params)
    Date.civil(params[:start_time][:year].to_i, params[:start_time][:month].to_i,
               params[:start_time][:day].to_i)
  end

  # Takes the horrible-looking form output and formats to Date
  def synthesize_end_date(params)
    Date.civil(params[:end_time][:year].to_i, params[:end_time][:month].to_i,
               params[:end_time][:day].to_i)
  end

  ###############################################################################

  def tutor_hours
    today = Time.zone.today
    if today.month < 6
      start_date = Date.parse("Jan 1 #{today.year}")
      end_date = Date.parse("Jun 1 #{today.year}")
    else
      start_date = Date.parse("Aug 1 #{today.year}")
      end_date = Date.parse("Dec 31 #{today.year}")
    end
    table = generate_tutor_query(start_date, end_date)
    tutor_table_iterate(table)
  end

  private

  def generate_tutor_query(start_date, end_date)
    User.joins('LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id')
        .where("(tutoring_sessions.session_status = 'Confirmed' \
                  OR tutoring_sessions.session_status = 'In-Person' OR \
                  tutoring_sessions.session_status IS NULL) AND users.id = ? AND \
                  (scheduled_datetime BETWEEN ? AND ? OR scheduled_datetime IS NULL)",
               current_user.id, start_date, end_date)
        .select("users.first_name,\
                  users.last_name,\
                  tutoring_sessions.scheduled_datetime,\
                  tutoring_sessions.completed_datetime")
  end

  # Returns how long a tutoring session lasted
  def entry_duration(entry)
    if !entry.completed_datetime.nil?
      (entry.completed_datetime - entry.scheduled_datetime) / 1.hour
    else
      0.0
    end
  end

  def tutor_table_iterate(table)
    hours_worked = 0
    table.each do |entry|
      # Update hours_worked
      hours_worked += entry_duration(entry)
    end
    hours_worked
  end
end
