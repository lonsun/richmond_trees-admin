class CreateAdoptionRequests < ActiveRecord::Migration
  def change
    create_table :adoption_requests do |t|
      t.belongs_to :tree

      t.timestamps
    end
  end
end
