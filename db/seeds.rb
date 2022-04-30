# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Admin.count == 0
  admin=Admin.new(email:'admin@admin.com',password:'12345678')
  admin.save(:validate=>false)
end

i = 0
employee = %w[Hamid Julie Marta Tiago Claudio Aslam Rajesh Cleo Casper Lokesh Karthik].map do |employee_name|
  Employee.create(name: employee_name, department: Employee::DEPARTMENTS[rand(Employee::DEPARTMENTS.count)])
  Employee.last.photo.attach(io: File.open("#{Rails.root}/public/Images/picture#{i}.jpeg"), filename: 'picture.jpeg', content_type: 'image/jpeg')
  i+=1
end

months = %w[January February March April May].map do |month|
  Mystery.mystery_lunches(month)
end
