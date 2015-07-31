module ReportsHelper

  # Plantings report
  def search_plantings( p )
    q = Planting.joins( :parent_adoption_request, :tree_species )
      .joins( 'LEFT JOIN "notes" ON "notes"."planting_id" = "plantings"."id"' )
      .where( plantings: { planted_on: Date.parse( p['planted_on_from'] )..Date.parse( p['planted_on_to'] ) } )
      .where( "adoption_requests.owner_first_name ILIKE ?", wildcard_if_empty( p['owner_first_name'] ) )
      .where( "adoption_requests.owner_last_name ILIKE ?", wildcard_if_empty( p['owner_last_name'] ) )
      .where( "adoption_requests.street_name ILIKE ?", wildcard_if_empty( p['street_name'] ) )
      .where( "adoption_requests.zip_code ILIKE ?", wildcard_if_empty( p['zip_code'] ) )
    
    # show all notes if no note search term was provided
    note_clause = "notes.note ILIKE ?"
    if p['note'].empty?
      note_clause += " OR notes.note is null"
    end
    q = q.where( note_clause, wildcard_if_empty( p['note'] ) )

    last_maintenance_date_clause = '( "plantings"."last_maintenance_date" BETWEEN \'' + p['last_maintenance_from'] + '\' AND \'' + p['last_maintenance_to'] + '\' )'      
    if p['include_nil_maintenance_records'] == 'yes'
      last_maintenance_date_clause += ' OR ( "plantings"."last_maintenance_date" is null )'
    end
    q = q.where( last_maintenance_date_clause )
    
    q = q.where( "adoption_requests.house_number > ?", p['house_number_gt'].to_i ) unless p['house_number_gt'].empty?
    q = q.where( "adoption_requests.house_number < ?", p['house_number_lt'].to_i ) unless p['house_number_lt'].empty?
    q = q.where( plantings: { stakes_removed: p['stakes_removed'] } ) unless p['stakes_removed'] == 'ignore'
    q = q.where( plantings: { tree_id: p['tree_id'] } ) unless p['tree_id'].empty?
    q = q.where( plantings: { last_status_code: p['last_status_code'] } ) unless p['last_status_code'].empty?

    q = q.group( "adoption_requests.house_number, adoption_requests.street_name, plantings.id" )

    q = q.order( "adoption_requests.street_name, adoption_requests.house_number" )

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