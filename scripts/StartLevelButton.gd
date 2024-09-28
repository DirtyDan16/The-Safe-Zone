extends Button



signal StartGame

func _on_pressed():
	StartGame.emit();
	visible = false;

