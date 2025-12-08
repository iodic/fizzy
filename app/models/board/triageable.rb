module Board::Triageable
  extend ActiveSupport::Concern

  DEFAULT_COLUMN_NAMES = [
    "In Progress",
    "In Review"
  ].freeze

  included do
    has_many :columns, dependent: :destroy

    after_create :create_default_columns
  end

  private
    def create_default_columns
      return if columns.exists?

      DEFAULT_COLUMN_NAMES.each do |name|
        columns.create!(name: name)
      end
    end
end
