class CreateNoteAccesses < ActiveRecord::Migration[8.2]
  def change
    create_table :note_accesses, id: :uuid do |t|
      t.uuid :note_id, null: false
      t.uuid :user_id, null: false
      t.timestamps
    end

    add_index :note_accesses, [ :note_id, :user_id ], unique: true
    add_index :note_accesses, :user_id
  end
end
