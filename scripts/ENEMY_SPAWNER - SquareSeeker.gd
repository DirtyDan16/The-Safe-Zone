extends Spawner

@export var EnemyScene: PackedScene
@export var enemySpeedRandomRange: Vector2 = Vector2(3,7)
@export var enemySpawnInRadiusRandomRange: Vector2 = Vector2(400,700)

signal addEnemy;

func _on_square_seeker_spawner_timeout() -> void:
	#print("enemy spawn")
	var enemy: Enemy = EnemyScene.instantiate();
	var radius: float = randf_range(enemySpawnInRadiusRandomRange[0], enemySpawnInRadiusRandomRange[1])  
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	
	enemy.position = Vector2(x, y)  + playerPos
	enemy.setSpeed(enemySpeedRandomRange[0],enemySpeedRandomRange[1]);
	addEnemy.emit(enemy)
