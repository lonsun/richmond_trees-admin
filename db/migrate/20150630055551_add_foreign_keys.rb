class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key "addresses", "adoption_requests", name: "addresses_adoption_request_id_fk", dependent: :delete
    add_foreign_key "adoption_requests", "trees", name: "adoption_requests_tree_id_fk"
    add_foreign_key "maintenance_records", "plantings", name: "maintenance_records_planting_id_fk", dependent: :delete
    add_foreign_key "notes", "plantings", name: "notes_planting_id_fk", dependent: :delete
    add_foreign_key "notes", "users", name: "notes_user_id_fk"
    add_foreign_key "people", "adoption_requests", name: "people_adoption_request_id_fk", dependent: :delete
    add_foreign_key "plantings", "adoption_requests", name: "plantings_adoption_request_id_fk", dependent: :delete
    add_foreign_key "plantings", "trees", name: "plantings_tree_id_fk"
  end
end
