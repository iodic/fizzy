require "test_helper"

class TimeEntryTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "create" do
    entry = TimeEntry.new(
      board: boards(:writebook),
      user: users(:david),
      card: cards(:layout),
      hours: 1.5,
      description: "Fix layout issues"
    )

    assert entry.save
    assert_equal boards(:writebook).account, entry.account
  end

  test "requires minimum hours" do
    entry = TimeEntry.new(
      board: boards(:writebook),
      user: users(:david),
      hours: 0.25,
      description: "Too small"
    )

    assert_not entry.valid?
    assert_includes entry.errors[:hours], "must be greater than or equal to 0.5"
  end

  test "card must belong to board" do
    entry = TimeEntry.new(
      board: boards(:writebook),
      user: users(:david),
      card: cards(:radio),
      hours: 1.0,
      description: "Mismatch board/card"
    )

    assert_not entry.valid?
    assert_includes entry.errors[:card], "must belong to the same board"
  end
end
