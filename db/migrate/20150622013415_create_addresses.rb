class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.belongs_to :adoption_request, index: true

      t.timestamps
    end
  end
end
