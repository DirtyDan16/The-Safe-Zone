extends Button



signal ResetGame

func _on_pressed():
	ResetGame.emit();
	visible = false;
