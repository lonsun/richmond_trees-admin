class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :note
      t.belongs_to :user, index: true
      t.belongs_to :planting, index: true

      t.timestamps
    end
  end
end
