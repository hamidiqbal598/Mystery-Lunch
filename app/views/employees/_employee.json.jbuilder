json.extract! employee, :id, :photo, :name, :department, :created_at, :updated_at
json.url employee_url(employee, format: :json)
json.photo url_for(employee.photo)
