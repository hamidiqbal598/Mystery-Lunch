require 'rails_helper'

RSpec.describe Mystery, type: :model do

  # Here we make object for a dummy data to validate it further
  let(:valid_attributes) {
    { status:true,month:'March', valid_till: "2022-06-30" }
  }

  describe "validation_with_proper_attribute_values" do

    let(:mystery) { Mystery.new(valid_attributes) }

    it "requires the valid_till with in 3 months range"  do
      # mystery.valid_till = "2022-07-30"
      # should expect(mystery).to_not be_valid
    end

  end

end
