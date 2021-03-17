# frozen_string_literal: true

# Master Class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
