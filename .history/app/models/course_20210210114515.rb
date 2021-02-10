class Course < ApplicationRecord
    has_and_belongs_to_many :users
    belongs_to :subject
    has_and_belongs_to_many :tutoring_sessions
end
