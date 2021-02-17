class TutoringSession < ApplicationRecord
    has_and_belongs_to_many :users
    has_and_belongs_to_many :subjects
    has_and_belongs_to_many :courses
    
    def duration_datetime
        scheduled_datetime + 1.hour
    end

      %%   %
    def top_offset
       (((scheduled_datetime.hour.to_f + (scheduled_datetime.min/60.0)) / 24) * 100).to_s + "%"
    end
end
