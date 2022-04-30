require 'rails_helper'

RSpec.describe "mysteries/new", type: :view do
  before(:each) do
    assign(:mystery, Mystery.new(
      status: false,
      month: "March"
    ))
  end

  it "renders new mystery form" do
    render

    assert_select "form[action=?][method=?]", mysteries_path, "post" do

      assert_select "input[name=?]", "mystery[status]"

      assert_select "input[name=?]", "mystery[month]"
    end
  end
end
