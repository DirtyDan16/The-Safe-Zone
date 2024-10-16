extends Spawner

@export var Collectable: PackedScene

signal addCollectable;

func _on_spawning_cooldown_timeout() -> void:
	var collectable: Object = Collectable.instantiate()
	var radius: float = randf_range(collectable.radiusOfSpawnRange[0],collectable.radiusOfSpawnRange[1])  
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	collectable.position = Vector2(x, y)  + playerPos
	addCollectable.emit(collectable,collectable.lifespan)
