require 'csv' 
file = "#{Rails.root}/public/tutoring_hours.csv"
table = User.joins("LEFT JOIN tutoring_sessions ON tutoring_sessions.tutor_id = users.id").where("tutoring_sessions.session_status = 'Confirmed' OR tutoring_sessions.session_status = 'In-Person'")
headers = ["Tutor Name", "Hours Worked"]
current_tutor = ''
hours worked = 0
CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
  entries.each do |entry| 
  writer << [product.id, product.name, product.price, product.description] 
  end
end