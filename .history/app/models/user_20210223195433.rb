include EncryptionService::Encryptable
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :tutoring_sessions
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :roles

  validate :email_domain
  #attr_encrypted :first_name, :last_name, :email
  attr_encrypted :first_name, :last_name
  def email_domain
    domain = email.split("@").last
    if !email.blank?
      errors.add(:email, "Invalid Domain. Please use your TAMU or Spartan email") if domain != "tamu.edu" and domain != "spartan-tutoring.com"
      errors.add(:email, "indicates wrong role selected. Please select \'Spartan Tutor\'") if domain == "spartan-tutoring.com"
    end
  end
end
