# frozen_string_literal: true

module AdminViewHoursHelper
  def admin_view_hours_exec
    unless current_user.roles.include?(Role.admin_role)
      redirect_to root_path
      return
    end
    include TutoringSessionExportHelper
    return unless request.post?

    start_date = params[:start_date]
    end_date = params[:end_date]
    create_csv(start_date, end_date)
  end
end
