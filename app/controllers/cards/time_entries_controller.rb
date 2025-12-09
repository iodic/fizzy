class Cards::TimeEntriesController < ApplicationController
  include CardScoped

  def index
    prepare_time_entries
  end

  def create
    @time_entry = @card.time_entries.new(time_entry_params.merge(user: Current.user))
    if @time_entry.save
      prepare_time_entries
      render :index
    else
      prepare_time_entries
      render :index, status: :unprocessable_entity
    end
  end

  private
    def time_entry_params
      params.require(:time_entry).permit(:hours, :description).merge(board: @board)
    end

    def prepare_time_entries
      @time_entry ||= @card.time_entries.new(board: @board, user: Current.user, hours: 0.5)
      @time_entries = @card.time_entries.includes(:user).recent
    end
end
