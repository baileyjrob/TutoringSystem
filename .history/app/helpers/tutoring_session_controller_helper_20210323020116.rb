# frozen_string_literal: true

# Helper functions for the tutoring session controller
module TutoringSessionControllerHelper
  def week_sessions(start_week)
    TutoringSession
      .where('scheduled_datetime BETWEEN ? AND ?', start_week, start_week + 1.week)
      .where('tutor_id = ?', current_user.id)
  end

  def cookie_offset(start_week)
    week_offset = cookies['week_offset'].to_f * 1.week
    cookies.delete 'week_offset'

    start_week += week_offset
    cookies['start_week'] = start_week.to_datetime.strftime('%Q')
    return start_week
  end

  def week_to_string(week)
    week.to_date.to_formatted_s(:long_ordinal)
  end

  def timezone_week_start
    Time.zone.at(cookies['start_week'].to_f / 1000).beginning_of_day
  end

  def date_week_start
    Time.zone.today.beginning_of_week.to_datetime
  end
end
