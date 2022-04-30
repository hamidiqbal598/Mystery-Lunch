require 'rails_helper'

RSpec.describe "mysteries/show", type: :view do
  before(:each) do
    @mystery = assign(:mystery, Mystery.create!(
      status: false,
      month: "Month"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Month/)
  end
end
