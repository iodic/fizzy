class CreateNotes < ActiveRecord::Migration[8.2]
  def change
    create_table :notes, id: :uuid do |t|
      t.uuid :account_id, null: false
      t.uuid :board_id, null: false
      t.uuid :user_id, null: false
      t.string :title, null: false
      t.timestamps
    end

    add_index :notes, :account_id
    add_index :notes, :board_id
    add_index :notes, :user_id
    add_index :notes, :updated_at
  end
end
