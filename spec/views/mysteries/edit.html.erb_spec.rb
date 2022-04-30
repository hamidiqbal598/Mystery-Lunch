require 'rails_helper'

RSpec.describe "mysteries/edit", type: :view do
  before(:each) do
    @mystery = assign(:mystery, Mystery.create!(
      status: false,
      month: "MyString"
    ))
  end

  it "renders the edit mystery form" do
    render

    assert_select "form[action=?][method=?]", mystery_path(@mystery), "post" do

      assert_select "input[name=?]", "mystery[status]"

      assert_select "input[name=?]", "mystery[month]"
    end
  end
end
