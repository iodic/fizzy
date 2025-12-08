require "test_helper"

class Board::TriageableTest < ActiveSupport::TestCase
  test "creates default columns on creation" do
    board = Current.set(session: sessions(:david), user: users(:david)) do
      Board.create!(name: "Fresh board")
    end

    assert_equal Board::Triageable::DEFAULT_COLUMN_NAMES, board.columns.sorted.pluck(:name)
  end
end
