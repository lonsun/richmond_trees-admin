#!/usr/bin/env ruby

# Script to import RT data (csv) into postgres.

# CSV fields -> database field -> database table:
# 0 -> planted_on -> plantings
# 1 -> event -> plantings
# 2 -> street_address -> addresses
# 3 -> zip_code -> addresses
# 4 -> placement -> plantings
# 5 -> plant_space_width -> plantings
# 6 -> common_name -> trees
# 7 -> owner_first_name -> adoption requests
# 8 -> owner_phone -> adoption requests
# 9 -> owner_email -> adoption requests
# 10 -> maintenance_date - 1 -> maintenance_record
# 11 -> maintenance_date - 2 -> maintenance_record
# 12 -> maintenance_date - 3 -> maintenance_record
# 13 -> maintenance_date - 4 -> maintenance_record
# 14 -> stakes_removed -> plantings
# 15 -> note -> notes

require 'csv'
require 'pg'
require 'date'

SPACE = ' '

# Prepared statement names
INSERT_ADDRESS = 'insert_address'
INSERT_PERSON = 'insert_person'
INSERT_ADOPTION_REQUEST = 'insert_adoption_request'
TREE_LOOKUP = 'get_tree_id'
INSERT_PLANTING = 'insert_planting'
INSERT_MAINTENANCE_RECORD = 'insert_maintenance_record'
INSERT_NOTE = 'insert_note'

# This is my user id in the system.
CREATED_BY = 1

# Maintenance record fields
STATUS_CODE = 'U'
REASON_CODES = ''
DBH = ''


# setup database connection
@conn = PG::Connection.new( :dbname => 'rt_test' )

## FUNCTIONS ##
# for debugging
def dump_row( row_num = 'not passed' )
  puts "\nRow number: #{ row_num.to_s }"
  puts "planted_on: #{@planted_on}"
  puts "event: #{@event}"
  puts "street_address: #{@street_address}"
  puts "zip_code: #{@zip_code}"
  puts "placement: #{@placement}"
  puts "plant_space_width: #{@plant_space_width}"
  puts "common_name: #{@common_name}"
  puts "owner_first_name: #{@owner_first_name}"
  puts "owner_last_name: #{@owner_last_name}"
  puts "owner_phone: #{@owner_phone}"
  puts "owner_email: #{@owner_email}"
  puts "maintenance_date1: #{@maintenance_date1}"
  puts "maintenance_date2: #{@maintenance_date2}"
  puts "maintenance_date3: #{@maintenance_date3}"
  puts "maintenance_date4: #{@maintenance_date4}"
  puts "stakes_removed: #{@stakes_removed}"
  puts "note: #{@note}"
end
    
# put row's values into holder objects
def marshal_row_values( row )
  planted_on = 				clean_data( row[0] )
  event = 						clean_data( row[1] )
  street_address = 		clean_data( row[2] )
  zip_code = 					clean_data( row[3] )
  placement = 				clean_data( row[4] )
  plant_space_width = clean_data( row[5] )
  common_name = 			clean_data( row[6] )
  full_name = 				clean_data( row[7] )
  phone = 						clean_data( row[8] )
  email = 						clean_data( row[9] )
  maintenance1 = 			clean_data( row[10] )
  maintenance2 = 			clean_data( row[11] )
  maintenance3 = 			clean_data( row[12] )
  maintenance4 = 			clean_data( row[13] )
  stakes_removed = 		clean_data( row[14] )
  note = 							clean_data( row[15] )

  @planted_on = planted_on
  @event = event
  @street_address = street_address
  @zip_code = zip_code
  @placement = placement
  @plant_space_width = plant_space_width
  @common_name = common_name
  # name is not split in the csv file
  @owner_first_name = full_name.split( SPACE ).first || ''
  @owner_last_name = full_name.split( SPACE ).last || ''
  @owner_phone = phone
  @owner_email = email
  #there is only a single maintenance date field in each maintenance record entry
  @maintenance_date1 = maintenance1
  @maintenance_date2 = maintenance2
  @maintenance_date3 = maintenance3
  @maintenance_date4 = maintenance4
  @stakes_removed = pg_boolean( stakes_removed )
  @note = note
end

# remove non-alphanumberic characters for comparison
def clean_for_comp( address = '' )
  address.gsub /[^0-9a-zA-Z]/, ''
end

def current_utc_datetime
	Time.now.utc.strftime( "%Y-%m-%d %H:%M:%S")
end

# the plantings.stakes_removed field is a boolean. 
# "y" values in the spreadsheet is true and anything else is false.
def pg_boolean( val )
	( val == 'y' ) ? 'true' : 'false'
end

# trim if var allows it.  Return empty string on no or nil value.
def clean_data( field )
	field.to_s.strip
end

## NOW DO THE WORK ##
@row_num = 0

# prepare statements for db
@conn.prepare( INSERT_ADOPTION_REQUEST, 'insert into adoption_requests
	( owner_first_name, owner_last_name, owner_email, owner_phone, street_address, city, state, zip_code, created_at, updated_at ) 
	values
	( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10 ) 
	returning id' )
@conn.prepare( TREE_LOOKUP, 'select id from trees where common_name = $1' )
@conn.prepare( INSERT_PLANTING, 'insert into plantings
	( adoption_request_id, tree_id, planted_on, event, placement, plant_space_width, stakes_removed, user_id, created_at, updated_at )
	values
	( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10 )
	returning id')
@conn.prepare( INSERT_MAINTENANCE_RECORD, 'insert into maintenance_records
	( status_code, reason_codes, diameter_breast_height, planting_id, maintenance_date, user_id, created_at, updated_at )
	values
	( $1, $2, $3, $4, $5, $6, $7, $8 )')
@conn.prepare( INSERT_NOTE, 'insert into notes
	( note, user_id, planting_id, created_at, updated_at )
	values
	( $1, $2, $3, $4, $5 )')

CSV.foreach( '/Users/lon/tmp/richmond trees/import/import_data/Plantings-Table 1.csv' ) do |row|
  @row_num += 1

  marshal_row_values( row )

  dump_row( @row_num )

  @conn.transaction { |conn|
    #Create Adoption Request and get id
    res = conn.exec_prepared( INSERT_ADOPTION_REQUEST, 
    	[ @owner_first_name, @owner_last_name, @owner_email, @owner_phone, @street_address, @city, @state, @zip_code, current_utc_datetime, current_utc_datetime ] )
    adoption_id = res.getvalue( 0, 0 )

    #Look up tree id
    res = conn.exec_prepared( TREE_LOOKUP, [ @common_name ] )
    tree_id = res.getvalue( 0, 0 )

    #Create Planting and get id
    res = conn.exec_prepared( INSERT_PLANTING, 
    	[ adoption_id, tree_id, @planted_on, @event, @placement, @plant_space_width, @stakes_removed, CREATED_BY, current_utc_datetime, current_utc_datetime ] )
    planting_id = res.getvalue( 0, 0 )

    #Create Maintenance Records for this Planting
    res = conn.exec_prepared( INSERT_MAINTENANCE_RECORD, 
    	[ STATUS_CODE, REASON_CODES, DBH, planting_id, @maintenance_date1, CREATED_BY, current_utc_datetime, current_utc_datetime ]) unless @maintenance_date1.empty?
    res = conn.exec_prepared( INSERT_MAINTENANCE_RECORD, 
    	[ STATUS_CODE, REASON_CODES, DBH, planting_id, @maintenance_date2, CREATED_BY, current_utc_datetime, current_utc_datetime ]) unless @maintenance_date2.empty?
    res = conn.exec_prepared( INSERT_MAINTENANCE_RECORD, 
    	[ STATUS_CODE, REASON_CODES, DBH, planting_id, @maintenance_date3, CREATED_BY, current_utc_datetime, current_utc_datetime ]) unless @maintenance_date3.empty?
    res = conn.exec_prepared( INSERT_MAINTENANCE_RECORD, 
    	[ STATUS_CODE, REASON_CODES, DBH, planting_id, @maintenance_date4, CREATED_BY, current_utc_datetime, current_utc_datetime ]) unless @maintenance_date4.empty?

    #Create Notes for this Planting
    res = conn.exec_prepared( INSERT_NOTE, [ @note, CREATED_BY, planting_id, current_utc_datetime, current_utc_datetime ] )
  }  

  exit

end
