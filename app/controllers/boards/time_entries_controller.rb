class Boards::TimeEntriesController < ApplicationController
  include BoardScoped

  def index
    prepare_time_tracking
  end

  def create
    @time_entry = @board.time_entries.new(time_entry_attributes)
    if @time_entry.save
      redirect_to board_time_entries_path(@board), notice: "Time entry logged"
    else
      prepare_time_tracking
      render :index, status: :unprocessable_entity
    end
  end

  private
    def time_entry_params
      params.require(:time_entry).permit(:hours, :description, :card_id, :user_id)
    end

    def time_entry_attributes
      attributes = time_entry_params.except(:user_id).to_h
      user = if time_entry_params[:user_id].present?
        @board.users.find(time_entry_params[:user_id])
      else
        Current.user
      end
      attributes.merge(user: user)
    end

    def prepare_time_tracking
      @time_entry ||= @board.time_entries.new(hours: 0.5, user: Current.user)
      @time_entry.user ||= Current.user
      @time_entries = @board.time_entries.includes(:user, :card).recent
      @card_options = @board.cards.order(number: :desc).map do |card|
        [ "##{card.number} · #{card.title.presence || "Untitled"}", card.id ]
      end
      @user_options = @board.users.active.distinct.order(:name)
    end
end
