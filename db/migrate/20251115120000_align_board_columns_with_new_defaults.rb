class AlignBoardColumnsWithNewDefaults < ActiveRecord::Migration[8.2]
  DEFAULT_COLUMN_NAMES = Board::Triageable::DEFAULT_COLUMN_NAMES

  def up
    say_with_time "Ensuring default board columns exist" do
      Account.find_each do |account|
        ::Current.set(account: account) do
          account.boards.find_each do |board|
            align_columns_for(board)
          end
        end
      end
    end
  end

  def down
    # No automatic rollback. Columns can be removed manually if needed.
  end

  private
    def align_columns_for(board)
      rename_column_if_present(board, "In progress", "In Progress")
      rename_column_if_present(board, "Review", "In Review")

      DEFAULT_COLUMN_NAMES.each do |name|
        next if column_exists?(board, name)

        board.columns.create!(name: name)
      end
    end

    def rename_column_if_present(board, current_name, new_name)
      column = board.columns.find_by("LOWER(name) = ?", current_name.downcase)
      column&.update!(name: new_name)
    end

    def column_exists?(board, name)
      board.columns.where("LOWER(name) = ?", name.downcase).exists?
    end
end
