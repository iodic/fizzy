require "test_helper"

class NoteTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "create note" do
    note = notes(:writebook_credentials)

    assert note.valid?
    assert_equal boards(:writebook).account, note.account
    assert note.viewable_by?(users(:david))
  end

  test "requires title" do
    note = boards(:writebook).notes.new(user: users(:david), title: "", body: "Content")

    assert_not note.valid?
    assert_includes note.errors[:title], "can't be blank"
  end

  test "requires body" do
    note = boards(:writebook).notes.new(user: users(:david), title: "Empty body")

    assert_not note.valid?
    assert_includes note.errors[:body], "can't be blank"
  end

  test "assign viewer ids" do
    note = boards(:writebook).notes.create!(user: users(:david), title: "Checklist", body: "Body")

    note.viewer_ids = [ users(:kevin).id ]
    assert note.viewable_by?(users(:kevin))
    assert note.viewable_by?(users(:david)), "Creator must retain access"
  end
end
