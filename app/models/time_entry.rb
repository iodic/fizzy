class TimeEntry < ApplicationRecord
  belongs_to :account
  belongs_to :board
  belongs_to :user
  belongs_to :card, optional: true

  before_validation :assign_account

  validates :description, presence: true
  validates :hours, numericality: { greater_than_or_equal_to: 0.5 }
  validate :card_matches_board

  scope :recent, -> { order(created_at: :desc) }

  private
    def assign_account
      self.board ||= card&.board
      self.account ||= board&.account
    end

    def card_matches_board
      return if card.blank?
      errors.add(:card, "must belong to the same board") unless card.board_id == board_id
    end
end
