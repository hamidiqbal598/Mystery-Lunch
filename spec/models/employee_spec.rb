require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:valid_attributes) {
    { name:'Hamid',department:'operations' }
  }

  describe "validation_with_proper_attribute_values" do

    let(:employee) { Employee.new(valid_attributes) }

    # It Validates the created dummy employee carrying name or not
    it { should validate_presence_of(:name) }

    # It Validates the created dummy employee carrying department or not
    it { should validate_presence_of(:department) }

    it "should allow valid values" do
      Employee::DEPARTMENTS.each do |v|
        should allow_value(v).for(:department)
      end
    end

  end
end
