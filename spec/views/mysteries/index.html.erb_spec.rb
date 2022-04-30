require 'rails_helper'

RSpec.describe "mysteries/index", type: :view do

  # before(:each) do
  #   assign(:mysteries, [
  #     Mystery.create!(
  #       status: false,
  #       month: "Month"
  #     ),
  #     Mystery.create!(
  #       status: false,
  #       month: "Month"
  #     )
  #   ])
  # end

  before(:each) do
    @mysteries = WillPaginate::Collection.new(4,10,0)
    31.times do
      @mysteries  << Mystery.create(status: false, month: "Month")
    end

  end

  it "renders a list of mysteries" do
    render
  end
end
