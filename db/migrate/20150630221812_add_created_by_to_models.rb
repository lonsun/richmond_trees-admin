class AddCreatedByToModels < ActiveRecord::Migration
  def change
    add_reference :adoption_requests, :user, index: true
    add_foreign_key "adoption_requests", "users", name: "adoption_requests_user_id_fk"

    add_reference :plantings, :user, index: true
    add_foreign_key "plantings", "users", name: "plantings_user_id_fk"

    add_reference :maintenance_records, :user, index: true
    add_foreign_key "maintenance_records", "users", name: "maintenance_records_user_id_fk"
  end
end
