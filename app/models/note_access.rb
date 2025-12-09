class NoteAccess < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :user_id, uniqueness: { scope: :note_id }
end
