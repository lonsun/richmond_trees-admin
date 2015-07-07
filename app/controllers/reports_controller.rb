class ReportsController < ApplicationController
  before_filter :require_user

  def plantings
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def plantings_report_params
      @planting = Planting.find(params[:id])
    end
end
