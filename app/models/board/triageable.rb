module Board::Triageable
  extend ActiveSupport::Concern

  DEFAULT_COLUMNS = {
    "In Progress" => "var(--color-card-3)",
    "In Review" => "var(--color-card-8)"
  }.freeze

  DEFAULT_COLUMN_NAMES = DEFAULT_COLUMNS.keys.freeze

  included do
    has_many :columns, dependent: :destroy

    after_create :create_default_columns
  end

  private
    def create_default_columns
      return if columns.exists?

      DEFAULT_COLUMNS.each do |name, color|
        columns.create!(name: name, color: color)
      end
    end
end
