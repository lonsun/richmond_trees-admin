class ReportsController < ApplicationController
  include ReportsHelper
  
  before_filter :require_user

  FROM_DATE_DEFAULT = '0001-01-01'
  TO_DATE_DEFAULT = '9999-01-01'

  def plantings
  end

  def plantings_results
    store_listing_referer

    search_params = plantings_report_params

    # clean up some params for search
    search_params['planted_on_from'] = FROM_DATE_DEFAULT if search_params['planted_on_from'].empty?
    search_params['planted_on_to'] = TO_DATE_DEFAULT if search_params['planted_on_to'].empty?
    search_params['last_maintenance_from'] = FROM_DATE_DEFAULT if search_params['last_maintenance_from'].empty?
    search_params['last_maintenance_to'] = TO_DATE_DEFAULT if search_params['last_maintenance_to'].empty?
    search_params['tree_id'] = remove_empty_values( search_params['tree_id'] )
    search_params['last_status_codes'] = remove_empty_values( search_params['last_status_codes'] )
    
    # do the search
    @results = search_plantings( search_params )

    respond_to do |format|
      format.html
      format.csv { send_data @results.to_csv }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def plantings_report_params
      params.permit( :planted_on_from, :planted_on_to, :owner_first_name, :owner_last_name, :street_name, 
        :zip_code, { :tree_id => [] }, :last_maintenance_from, :last_maintenance_to, :include_nil_maintenance_records,
        { :last_status_codes => [] }, :note, :stakes_removed, :house_number_gt, :house_number_lt, :zone )
    end
end
