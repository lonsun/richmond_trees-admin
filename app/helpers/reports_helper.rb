module ReportsHelper

  # Plantings report
  def search_plantings( p )
    q = Planting.joins( :parent_adoption_request, :tree_species )
      .joins( 'LEFT JOIN "notes" ON "notes"."planting_id" = "plantings"."id"' )
      .where.not( ignore: true )
      .where( plantings: { planted_on: Date.parse( p['planted_on_from'] )..Date.parse( p['planted_on_to'] ) } )
      .where( "adoption_requests.owner_first_name ILIKE ?", wildcard_if_empty( p['owner_first_name'] ) )
      .where( "adoption_requests.owner_last_name ILIKE ?", wildcard_if_empty( p['owner_last_name'] ) )
      .where( "adoption_requests.street_name ILIKE ?", wildcard_if_empty( p['street_name'] ) )
      .where( "adoption_requests.zip_code ILIKE ?", wildcard_if_empty( p['zip_code'] ) )

    q = q.where( adoption_requests: { zone_id: p['zone_ids'] } ) unless p['zone_ids'].empty?

    # show all notes if no note search term was provided
    note_clause = "( notes.note ILIKE ? AND notes.ignore != 't' )"
    if p['note'].empty?
      note_clause += " OR notes.note is null"
    end
    q = q.where( note_clause, wildcard_if_empty( p['note'] ) )

    last_maintenance_date_clause = '( "plantings"."last_maintenance_date" BETWEEN \'' + p['last_maintenance_from'] + '\' AND \'' + p['last_maintenance_to'] + '\' )'
    if p['include_nil_maintenance_records'] == 'yes'
      last_maintenance_date_clause += ' OR ( "plantings"."last_maintenance_date" is null )'
    end
    q = q.where( last_maintenance_date_clause )

    q = q.where( "adoption_requests.house_number >= ?", p['house_number_gt'].to_i ) unless p['house_number_gt'].empty?
    q = q.where( "adoption_requests.house_number <= ?", p['house_number_lt'].to_i ) unless p['house_number_lt'].empty?
    q = q.where( plantings: { stakes_removed: p['stakes_removed'] } ) unless p['stakes_removed'] == 'ignore'
    q = q.where( plantings: { initial_checks_received: p['initial_checks_received'] } ) unless p['initial_checks_received'] == 'ignore'
    q = q.where( plantings: { tree_id: p['tree_id'] } ) unless p['tree_id'].empty?

    if p['last_status_codes'].empty?
      last_status_code_clause = '( "plantings"."last_status_code" is null )'
    else
      last_status_code_clause = '( "plantings"."last_status_code" in (' + p['last_status_codes'].map { |v| "'#{ v }'" }.join(",") + ') )'

      # A status code is only present if there is at least one maintenance record.
      if p['include_nil_maintenance_records'] == 'yes'
        last_status_code_clause += ' OR ( "plantings"."last_status_code" is null )'
      end
    end
    q = q.where( last_status_code_clause )


    q = q.group( "adoption_requests.zone_id, adoption_requests.house_number, adoption_requests.street_name, plantings.id" )

    q = q.order( "adoption_requests.zone_id, adoption_requests.street_name, adoption_requests.house_number" )

    q
  end

  # Plantings report
  def search_adoption_requests( p )
    q = AdoptionRequest
      .where.not( ignore: true )
      .where( "street_name ILIKE ?", wildcard_if_empty( p['street_name'] ) )
      .where( "zip_code ILIKE ?", wildcard_if_empty( p['zip_code'] ) )

    q = q.where( zone_id: p['zone_ids'] ) unless p['zone_ids'].empty?

    # due to legacy data, received on dates can be nil or have a date...
    received_on_clause = '("adoption_requests"."received_on" BETWEEN \'' + p['received_on_from'] + '\' AND \'' + p['received_on_to'] + '\' )'
    if p['include_nil_received_on'] == 'yes'
      received_on_clause += ' OR ( "adoption_requests"."received_on" is null )'
    end
    q = q.where( received_on_clause )

    q = q.where( "house_number >= ?", p['house_number_gt'].to_i ) unless p['house_number_gt'].empty?
    q = q.where( "house_number <= ?", p['house_number_lt'].to_i ) unless p['house_number_lt'].empty?
    q = q.where( completed: p['completed'] ) unless p['completed'] == 'ignore'

    q = q.order( "zone_id, street_name, house_number" )

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
