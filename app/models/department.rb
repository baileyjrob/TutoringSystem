class Department < ApplicationRecord
    has_many :courses
    has_and_belongs_to_many :tutoring_sessions
end
