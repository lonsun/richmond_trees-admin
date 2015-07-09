module ReportsHelper

  # Plantings report
  def search_plantings( params )
    q = Planting.joins( :parent_adoption_request, :tree_species )
      .joins( 'LEFT JOIN "notes" ON "notes"."planting_id" = "plantings"."id"' )
      .where( plantings: { planted_on: Date.parse( params['planted_on_from'] )..Date.parse( params['planted_on_to'] ) } )
      .where( "adoption_requests.owner_first_name ILIKE ?", wildcard_if_empty( params['owner_first_name'] ) )
      .where( "adoption_requests.owner_last_name ILIKE ?", wildcard_if_empty( params['owner_last_name'] ) )
      .where( "adoption_requests.street_address ILIKE ?", wildcard_if_empty( params['street_address'] ) )
      .where( "adoption_requests.zip_code ILIKE ?", wildcard_if_empty( params['zip_code'] ) )
      .where( "notes.note ILIKE ?", wildcard_if_empty( params['note'] ) )

    last_maintenance_date_clause = '( ( "plantings"."last_maintenance_date" BETWEEN \'' + params['last_maintenance_from'] + '\' AND \'' + params['last_maintenance_to'] + '\' )'  
    
    if params['include_nil_maintenance_records'] == 'yes'
      last_maintenance_date_clause = last_maintenance_date_clause + ' OR ( "plantings"."last_maintenance_date" is null ) )'
    else
      last_maintenance_date_clause = last_maintenance_date_clause + ' )'
    end

    q = q.where( last_maintenance_date_clause )

    q = q.where( plantings: { stakes_removed: params['stakes_removed'] } ) unless params['stakes_removed'] == 'ignore'
    q = q.where( plantings: { tree_id: params['tree_id'] } ) unless params['tree_id'].empty?
    q = q.where( plantings: { last_status_code: params['last_status_code'] } ) unless params['last_status_code'].empty?

    q = q.group( "plantings.id" )

    q
  end

  # empty search terms should not filter results
  def wildcard_if_empty( var )
    raise ArgumentError unless var.respond_to?( :to_s )

    ( var.to_s.empty? ) ? "%" :  var
  end

  # remove empty values from an array
  def remove_empty_values( arr )
    raise ArgumentError.new( 'The argument must be an array.' ) unless arr.is_a?( Array )

    arr.reject { |a| ( a.empty? if a.is_a?( String ) ) }
  end
end