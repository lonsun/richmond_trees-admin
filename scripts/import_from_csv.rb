#!/usr/bin/env ruby

# Script to import RT data (csv) into postgres.

# CSV fields -> database field -> database table (expected format).  
# An asterisk at the end means a valid value is required.
#
# 0 -> planted_on -> plantings (YYYY-MM-DD)*
# 1 -> event -> plantings (text)
# 2 -> street_address -> addresses (street address)* NOTE THAT THIS FIELD IS NOW OBSOLETE. IT HAS BEEN REPLACED WITH SEPARATE HOUSE_NUMBER AND STREET_NAME FIELDS.  YOU MUST FIX THIS BEFORE USING THIS SCRIPT.
# 3 -> zip_code -> addresses (zip code)
# 4 -> placement -> plantings (text)
# 5 -> plant_space_width -> plantings (text)
# 6 -> common_name -> trees (text)*
# 7 -> owner_first_name -> adoption requests (text)
# 8 -> owner_phone -> adoption requests (phone number, any format)
# 9 -> owner_email -> adoption requests (email address)
# 10 -> maintenance_date 1 -> maintenance_record (YYYY-MM-DD)
# 11 -> maintenance_date 2 -> maintenance_record (YYYY-MM-DD)
# 12 -> maintenance_date 3 -> maintenance_record (YYYY-MM-DD)
# 13 -> maintenance_date 4 -> maintenance_record (YYYY-MM-DD)
# 14 -> stakes_removed -> plantings (should be "y" for true.  Anything else is false.)
# 15 -> note -> notes (text)
#
# NOTE that the trees need to be prepopulated in the target database with the correct "common name"
# for the import to work!

# The script should be passed a single argument that specifies
# the CSV file to parse.
usage = "Usage: #{ File.basename( $0 ) } [ import file ]"
abort( "Error: Wrong number of arguments passed.\n#{ usage }" ) if ARGV.count != 1

file_to_parse = ARGV[0]

require 'csv'
require 'pg'
require 'date'

SPACE = ' '

# Prepared statement names
INSERT_ADDRESS = 'insert_address'
INSERT_PERSON = 'insert_person'
INSERT_ADOPTION_REQUEST = 'insert_adoption_request'
TREE_LOOKUP = 'tree_lookup'
INSERT_PLANTING = 'insert_planting'
INSERT_MAINTENANCE_RECORD = 'insert_maintenance_record'
INSERT_NOTE = 'insert_note'

# This is my user id in the system.
CREATED_BY = 2

# Maintenance record fields
STATUS_CODE = 'U'
REASON_CODES = ''
DBH = 'unknown'

# setup database connection
@conn = PG::Connection.new( :dbname => 'rt_dev' )

# for debugging
def dump_row
  puts "\nRow number: #{ @row_num.to_s }"
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

# remove non-alphanumberic characters for comparison
def clean_for_comp( address = '' )
  address.upcase.gsub /[^0-9A-Z]/, ''
end

def current_utc_datetime
	Time.now.utc.strftime( "%Y-%m-%d %H:%M:%S")
end

# trim if var allows it.  Return empty string on no or nil value.
def clean_data( field )
	field.to_s.strip
end

# prepare statements for db
@conn.prepare( INSERT_ADOPTION_REQUEST, 'insert into adoption_requests
	( owner_first_name, owner_last_name, owner_email, owner_phone, street_address, city, state, zip_code, user_id, created_at, updated_at ) 
	values
	( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11 ) 
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

# now do the work
@row_num = 0
@street_addresses = {}

CSV.foreach( file_to_parse ) do |row|
  @row_num += 1

  # Marshal values for this row
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
  @stakes_removed = ( stakes_removed == 'y' ) ? 'true' : 'false'
  @note = note

  # log
  dump_row

  # add to db
  @conn.transaction { |conn|
    #Create Adoption Request and get id, if appropriate.
    #For the purposes of this import, an adoption request is uniquely identified by the street address.
    address_for_comp = clean_for_comp( @street_address )
    
    if @street_addresses.has_key?( address_for_comp )
    	adoption_id = @street_addresses[address_for_comp]
    else
	    res = conn.exec_prepared( INSERT_ADOPTION_REQUEST, 
	    	[ @owner_first_name, @owner_last_name, @owner_email, @owner_phone, @street_address, @city, @state, @zip_code, CREATED_BY, current_utc_datetime, current_utc_datetime ] )
	    adoption_id = res.getvalue( 0, 0 )
    	
    	@street_addresses[address_for_comp] = adoption_id
	  end

    #Look up tree id for use in planting
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
end
