extends "res://scripts/level_skeleton.gd"


func _ready():
	PLAYER_HP = 200;
	PLAYER_SPEED = 600
	SAFE_ZONE_MIN_SPEED = 100
	SAFE_ZONE_MAX_SPEED = 150
	DASH_AMOUNT = 300
	DASH_SPEED = 2000
	
	player.setHP(PLAYER_HP)
	player.setSpeed(PLAYER_SPEED)
	player.setDashAmount(DASH_AMOUNT)
	player.setDashSpeed(DASH_SPEED)

func game_start():
	super.game_start();
	$"ENEMY_SPAWNER - SquareSeeker".activate()

func game_over():
	super.game_over()
	$"ENEMY_SPAWNER - SquareSeeker".deactivate()

func _on_gui_reset_game():
		get_tree().change_scene_to_file("res://scenes/Levels/level_1.tscn")
