# frozen_string_literal: true

module UserControllerHelper
  def pending_mail_with(tutor, student)
    TutoringSessionMailer.with(to: tutor, student: student)
  end

  def create_or_update_link_for(user, tutoring_session)
    link = TutoringSessionUser.find_or_create_by(tutoring_session: tutoring_session, user: user)
    link.link_status = 'pending'
    link.save

    Notification.notify_student_application_for(tutoring_session.tutor, user, link)
  end
end
