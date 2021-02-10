class TutoringSession < ApplicationRecord
    has_and_belongs_to_many :users
    has_and_belongs_to_many :subjects
    has_and_belongs_to_many :courses
end
