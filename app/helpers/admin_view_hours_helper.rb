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
end
