require 'rails_helper'

RSpec.describe Admin, type: :model do

  # Here we make object for a dummy data to validate it further
  let(:valid_attributes) {
    { email:'admin@admin.com',password:'12345678' }
  }

  context "validation_with_proper_attribute_values" do

    let(:admin) { Admin.new(valid_attributes) }

    # It Validates the created dummy admin carrying email or not
    it { should validate_presence_of(:email) }

    # It Validates the created dummy admin carrying password or not
    it { should validate_presence_of(:password) }

  end
end
