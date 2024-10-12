extends "res://scripts/level_skeleton.gd"



func _ready():
	super._ready()
	
	SAFE_ZONE_MIN_SPEED = 100
	SAFE_ZONE_MAX_SPEED = 150

func game_start():
	super.game_start();
	
	_on_swap_out_environment_bullet_type_delay_timeout()

	for enemySpawner in enemySpawners:
		enemySpawner.activate()
	for collectableSpawner in collectableSpawners:
		collectableSpawner.activate()

func game_over():
	super.game_over()
	
	for enemySpawner in enemySpawners:
		enemySpawner.deactivate()
	for collectableSpawner in collectableSpawners:
		collectableSpawner.deactivate()
	for bulletHellProjectile in bulletHellProjectiles:
		bulletHellProjectile.deactivate()

func _on_gui_reset_game():
	get_tree().change_scene_to_file("res://scenes/Levels/level_1.tscn")

func _on_swap_out_environment_bullet_type_delay_timeout():
	for bulletHellProjectile in bulletHellProjectiles:
		bulletHellProjectile.deactivate()
	bulletHellProjectiles[randi_range(0,bulletHellProjectiles.size()-1)].activate()
