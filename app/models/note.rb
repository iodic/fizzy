class Note < ApplicationRecord
  belongs_to :account
  belongs_to :board
  belongs_to :user

  has_rich_text :body

  has_many :note_accesses, dependent: :delete_all
  has_many :viewers, through: :note_accesses, source: :user

  before_validation :assign_account
  after_create :ensure_creator_access
  after_save :ensure_creator_access

  validates :title, presence: true
  validates :body, presence: true
  validates :board, presence: true
  validates :user, presence: true

  scope :recent, -> { order(updated_at: :desc) }
  scope :viewable_by, ->(user) {
    joins(:note_accesses).where(note_accesses: { user_id: user.id }).distinct
  }

  def viewable_by?(user)
    viewers.exists?(id: user.id)
  end

  def viewer_ids=(ids)
    ids = Array(ids).map(&:presence).compact.collect(&:to_s)
    ids << user_id&.to_s if user_id.present?
    ids = ids.uniq

    allowed_users = board.users.where(id: ids)
    transaction do
      note_accesses.where.not(user_id: allowed_users.select(:id)).delete_all
      remaining_ids = note_accesses.pluck(:user_id)
      (allowed_users.pluck(:id) - remaining_ids).each do |new_id|
        note_accesses.create!(user_id: new_id)
      end
    end
  end

  private
    def assign_account
      self.account ||= board&.account
    end

    def ensure_creator_access
      return unless user
      note_accesses.find_or_create_by!(user: user)
    end
end
