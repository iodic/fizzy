class CleanupLegacyDoneColumns < ActiveRecord::Migration[8.2]
  def up
    say_with_time "Cleaning up legacy Done board columns" do
      Column.where("LOWER(name) = ?", "done").find_each do |column|
        column.cards.update_all(column_id: nil)
        column.destroy!
      end
    end
  end

  def down
    # Irreversible
  end
end
