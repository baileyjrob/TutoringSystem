# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read_at: nil) }

  def self.notify_student_application_for(tutor, actor, link)
    tutor.notifications.create(
      actor: actor,
      action: 'student_application',
      notifiable: link
    )
  end
end
