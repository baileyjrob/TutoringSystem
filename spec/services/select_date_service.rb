# frozen_string_literal: true

require 'active_support/core_ext'
module SelectDateHelper
  
  # By default, select_date fields are borderline impossible to test with spec.
  # Each unit being a separate attribute with separate formatting makes it
  # ridiculously hard to fill out elements. This service handles that for
  # you.

  # If view looks like select_date(prefix: 'start_time')
  # Then on spec, use select_date(desired_start_time, from: 'start_time')
  def select_date(date, options = {})
    date = date.to_date if date.instance_of? DateTime
    field = options[:from]
    select date.strftime('%Y'),  from: "#{field}[year]" # year
    select date.strftime('%B'),  from: "#{field}[month]" # month
    select date.strftime('%-d'), from: "#{field}[day]" # day
  end
end
