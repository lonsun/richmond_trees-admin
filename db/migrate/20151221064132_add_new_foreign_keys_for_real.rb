class AddNewForeignKeysForReal < ActiveRecord::Migration
  def change
    add_foreign_key "adoption_requests", "zones", name: "adoption_requests_zone_id_fk"
    add_foreign_key "zones", "users", name: "zones_user_id_fk"
  end
end
