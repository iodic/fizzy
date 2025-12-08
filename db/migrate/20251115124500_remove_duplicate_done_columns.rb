class RemoveDuplicateDoneColumns < ActiveRecord::Migration[8.2]
  def up
    say_with_time "Removing board columns named Done" do
      Column.where("LOWER(name) = ?", "done").find_each do |column|
        column.cards.update_all(column_id: nil)
        column.destroy!
      end
    end
  end

  def down
    # No rollback, columns can be recreated manually if desired.
  end
end
