class Boards::NotesController < ApplicationController
  include BoardScoped

  before_action :set_note, only: %i[show edit update destroy]
  before_action :set_available_users, only: %i[new create edit update]
  before_action :ensure_note_access!, only: %i[show edit update destroy]

  def index
    @notes = @board.notes.includes(:user, :rich_text_body).viewable_by(Current.user).recent
  end

  def show
  end

  def new
    @note = @board.notes.new(user: Current.user)
    @selected_user_ids = [ Current.user.id.to_s ]
  end

  def edit
    @selected_user_ids = @note.viewers.pluck(:id).map(&:to_s)
  end

  def create
    @note = @board.notes.new(note_params.merge(user: Current.user))

    if @note.save
      update_note_viewers
      redirect_to board_note_path(@board, @note), notice: "Note created"
    else
      @selected_user_ids = (viewer_ids_param + [ Current.user.id.to_s ]).uniq
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      update_note_viewers
      redirect_to board_note_path(@board, @note), notice: "Note updated"
    else
      @selected_user_ids = (viewer_ids_param + [ Current.user.id.to_s ]).uniq
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    redirect_to board_notes_path(@board), notice: "Note deleted"
  end

  private
    def note_params
      params.require(:note).permit(:title, :body)
    end

    def viewer_ids_param
      Array(params.dig(:note, :viewer_ids)).map(&:presence).compact
    end

    def update_note_viewers
      ids = viewer_ids_param
      ids << Current.user.id.to_s if ids.exclude?(Current.user.id.to_s)
      allowed_users = @board.users.where(id: ids)
      @note.viewer_ids = allowed_users.pluck(:id)
    end

    def set_note
      @note = @board.notes.includes(:rich_text_body).find(params[:id])
    end

    def set_available_users
      @available_users = @board.users.active.distinct.order(:name)
    end

    def ensure_note_access!
      head :forbidden unless @note.viewable_by?(Current.user)
    end
end
