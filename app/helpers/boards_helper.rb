module BoardsHelper
  def link_back_to_board(board)
    back_link_to board.name, board, "keydown.left@document->hotkey#click keydown.esc@document->hotkey#click click->turbo-navigation#backIfSamePath"
  end

  def link_to_edit_board(board)
    link_to edit_board_path(board), class: "btn", data: { controller: "tooltip" } do
      icon_tag("settings") + tag.span("Settings for #{board.name}", class: "for-screen-reader")
    end
  end

  def link_to_board_time_entries(board)
    link_to board_time_entries_path(board), class: "btn", data: { controller: "tooltip" } do
      icon_tag("clock") + tag.span("Time tracking for #{board.name}", class: "for-screen-reader")
    end
  end
end
