# frozen_string_literal: true

# Record of Users registered to the system
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  # has_and_belongs_to_many :tutoring_sessions
  has_many :tutoring_session_users, dependent: :delete_all
  has_many :tutoring_sessions, through: :tutoring_session_users do
    def push(tsessions, link_status, user)
      tsessions.map do |session|
        TutoringSessionUser.create(tutoring_session: session, user: user, link_status: link_status)
      end
    end
  end
  # has_and_belongs_to_many :courses
  has_many :course_users, dependent: :delete_all
  has_many :courses, through: :course_users
  # has_and_belongs_to_many :roles
  has_many :role_users, dependent: :delete_all
  has_many :roles, through: :role_users
  # has_and_belongs_to_many :course_requests
  has_many :course_request_users, dependent: :delete_all
  has_many :course_requests, through: :course_request_users

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy, inverse_of: false

  has_many :sessions_tutoring, class_name: 'TutoringSession', foreign_key: 'tutor_id',
                               dependent: :destroy, inverse_of: :tutor

  validates :first_name, :last_name, :email, presence: true
  validate :email_domain

  after_create :add_student_role, :add_spartan_tutor_role

  def email_domain
    domain = email.split('@').last if email.present?
    return unless email.present? && domain != 'tamu.edu' && domain != 'spartan-tutoring.com'

    errors.add(:email, 'Invalid Domain. Please use your TAMU or Spartan email')
  end

  def add_student_role
    domain = email.split('@').last if email.present?
    return unless email.present? && domain == 'tamu.edu'

    @role = Role.where(role_name: 'Student')
    roles.push(@role)
  end

  def add_spartan_tutor_role
    domain = email.split('@').last if email.present?
    return unless email.present? && domain == 'spartan-tutoring.com'

    @role = Role.where(role_name: 'Spartan Tutor')
    roles.push(@role)
  end

  def admin?
    roles.admin_role != nil
  end

  def student?
    roles.student_role != nil
  end

  def tutor?
    roles.tutor_role != nil
  end

  def spartan_tutor?
    roles.spartan_tutor_role != nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :major, :mu,
                                 :outfit, :email, :encrypted_password,
                                 role_ids: [], course_ids: [])
  end
end
