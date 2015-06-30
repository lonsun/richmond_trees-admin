class AddCreatedByToTrees < ActiveRecord::Migration
  def change
    add_reference :trees, :user, index: true
    add_foreign_key "trees", "users", name: "trees_user_id_fk"
  end
end
