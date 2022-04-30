class MysteriesController < ApplicationController
  before_action :set_mystery, only: %i[ show edit update destroy ]

  def index
    @mysteries = Mystery.filter_results(params)
  end

  def show
  end

  def new
    @mystery = Mystery.new
  end

  def edit
  end

  def create
    @mystery = Mystery.new(mystery_params)
    @mystery.valid_till = DateTime.now() + 3.months - 1.day
    respond_to do |format|
      if @mystery.save
        format.html { redirect_to mystery_url(@mystery), notice: "Mystery was successfully created." }
        format.json { render :show, status: :created, location: @mystery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mystery.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @mystery.update(mystery_params)
        format.html { redirect_to mystery_url(@mystery), notice: "Mystery was successfully updated." }
        format.json { render :show, status: :ok, location: @mystery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mystery.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mystery.destroy
    respond_to do |format|
      format.html { redirect_to mysteries_url, notice: "Mystery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def current_month_mystery
    @mysteries = Mystery.all.active.search_by_month(Date.today.strftime("%B"))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mystery
      @mystery = Mystery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mystery_params
      params.require(:mystery).permit(:status, :month, :valid_til)
    end
end
