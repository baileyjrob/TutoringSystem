# frozen_string_literal: true

require 'active_support/core_ext'
module SelectDateHelper
  # def select_date(date, options = {})
  #   field = options[:from]
  #   base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
  #   year, month, day = date.split(',')
  #   select year,  :from => "#{base_id}_1i"
  #   select month, :from => "#{base_id}_2i"
  #   select day,   :from => "#{base_id}_3i"
  # end

  def select_date(date, options = {})
    date = date.to_date if date.instance_of? DateTime
    field = options[:from]
    select date.strftime('%Y'),  from: "#{field}[year]" # year
    select date.strftime('%B'),  from: "#{field}[month]" # month
    select date.strftime('%-d'), from: "#{field}[day]" # day
  end
end
