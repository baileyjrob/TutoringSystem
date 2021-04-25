# frozen_string_literal: true

module SpartanSessionsHelper
  module_function

  def create(params)
    SpartanSession.create(course: params[:course],
                          semester: params[:semester],
                          session_datetime: params[:session_datetime]
                                            .in_time_zone("Central Time (US & Canada)"),
                          first_code: params[:check_in_code],
                          second_code: params[:check_out_code])
  end

  def update(params)
    SpartanSession.find(params[:id])
                  .update(course: params[:spartan_session][:course],
                          semester: params[:spartan_session][:semester],
                          session_datetime: params[:spartan_session][:session_datetime]
                                            .in_time_zone("Central Time (US & Canada)"),
                          first_code: params[:spartan_session][:check_in_code],
                          second_code: params[:spartan_session][:check_out_code])
  end
end
