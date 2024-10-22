extends "res://scripts/level_skeleton.gd"

#HIGH SCORE: 7620

func _ready():
	super._ready()
func game_start():
	super.game_start();
func game_over():
	super.game_over()

func _on_gui_reset_game():
	get_tree().change_scene_to_file("res://scenes/Levels/level_1.tscn")
