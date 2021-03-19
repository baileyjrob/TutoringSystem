class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :tutoring_sessions
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :roles

  validates :first_name, presence: true
  validates :last_name, presence: true

  validate :email_domain
  def email_domain
    if email == nil
      errors.add(:email, "Email missing.")
    else
      domain = email.split("@").last
      unless email.blank?
        errors.add(:email, "Invalid Domain. Please use your TAMU or Spartan email") if domain != "tamu.edu" and domain != "spartan-tutoring.com"
        #errors.add(:email, "indicates wrong role selected. Please select \'Spartan Tutor\'") if domain == "spartan-tutoring.com"
      end
    end
  end
end
