class CreateTimeEntries < ActiveRecord::Migration[8.2]
  def change
    create_table :time_entries, id: :uuid do |t|
      t.uuid :account_id, null: false
      t.uuid :board_id, null: false
      t.uuid :user_id, null: false
      t.uuid :card_id
      t.decimal :hours, precision: 6, scale: 2, null: false
      t.text :description, null: false
      t.timestamps
    end

    add_index :time_entries, :account_id
    add_index :time_entries, :board_id
    add_index :time_entries, :user_id
    add_index :time_entries, :card_id
    add_index :time_entries, :created_at
  end
end
