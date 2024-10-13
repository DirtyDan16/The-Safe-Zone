extends Node2D

@export var Collectable: PackedScene
@export var delay: float = 20 ##time between each spawn of said collectable


@onready var spawnerTimer = $Timer

signal addCollectable;

func _ready():
	spawnerTimer.wait_time = delay

func activate():
	spawnerTimer.start();

func deactivate():
	spawnerTimer.stop();


func _on_timer_timeout():
	var collectable: Object = Collectable.instantiate()
	var radius: float = randf_range(collectable.radiusOfSpawnRange[0],collectable.radiusOfSpawnRange[1])  
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	collectable.position = Vector2(x, y)  + playerPos
	addCollectable.emit(collectable,collectable.lifespan)
