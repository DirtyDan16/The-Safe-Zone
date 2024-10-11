extends "res://scripts/level_skeleton.gd"



func _ready():
	enemySpawners = list_of_enemy_spawners.get_children()
	SAFE_ZONE_MIN_SPEED = 100
	SAFE_ZONE_MAX_SPEED = 150

func game_start():
	super.game_start();

	for enemySpawner in enemySpawners:
		enemySpawner.activate()

func game_over():
	super.game_over()
	for enemySpawner in enemySpawners:
		enemySpawner.deactivate()

func _on_gui_reset_game():
		get_tree().change_scene_to_file("res://scenes/Levels/level_1.tscn")
