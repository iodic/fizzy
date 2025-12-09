class SetDefaultColumnColors < ActiveRecord::Migration[8.2]
  DEFAULT_COLUMNS = Board::Triageable::DEFAULT_COLUMNS

  def up
    say_with_time "Updating default board column colors" do
      DEFAULT_COLUMNS.each do |name, color|
        Column.where("LOWER(name) = ?", name.downcase).update_all(color: color)
      end
    end
  end

  def down
    # irreversible
  end
end
