# frozen_string_literal: true

# Record of Users registered to the system
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  # has_and_belongs_to_many :tutoring_sessions
  has_many :tutoring_session_users, dependent: :delete_all
  has_many :tutoring_sessions, through: :tutoring_session_users
  # has_and_belongs_to_many :courses
  has_many :course_users, dependent: :delete_all
  has_many :courses, through: :course_users
  # has_and_belongs_to_many :roles
  has_many :role_users, dependent: :delete_all
  has_many :roles, through: :role_users

  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy, inverse_of: false

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

  def full_name
    "#{first_name} #{last_name}"
  end
end
