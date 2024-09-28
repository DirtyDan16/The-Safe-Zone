extends CanvasLayer

signal StartGame
signal ResetGame

func _on_start_level_button_start_game():
	StartGame.emit()


func _on_reset_level_button_reset_game():
	ResetGame.emit()
