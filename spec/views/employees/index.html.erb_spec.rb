require 'rails_helper'

RSpec.describe "employees/index", type: :view do

  before(:each) do
    @employees = WillPaginate::Collection.new(4,10,0)
    31.times do
      emp = Employee.create!(name: "Name", department: "sales")
      emp.photo.attach(io: File.open("#{Rails.root}/public/Images/picture#{1}.jpeg"), filename: 'picture.jpeg', content_type: 'image/jpeg')
      @employees << emp
    end
    assign(:products, @products)
  end


  it "renders a list of employees" do
    render
  end
end
