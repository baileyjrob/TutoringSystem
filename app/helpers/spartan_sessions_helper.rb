# frozen_string_literal: true

module SpartanSessionsHelper
  module_function

  def create(params)
    SpartanSession.create(semester: params[:semester],
                          session_datetime: params[:session_datetime],
                          first_code: params[:check_in_code],
                          second_code: params[:check_out_code])
  end

  def update(params)
    SpartanSession.find(params[:id])
                  .update(semester: params[:spartan_session][:semester],
                          session_datetime: params[:spartan_session][:session_datetime],
                          first_code: params[:spartan_session][:check_in_code],
                          second_code: params[:spartan_session][:check_out_code])
  end
end
