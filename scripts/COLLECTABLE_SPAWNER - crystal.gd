extends Node2D

@export var CrystalScene: PackedScene
@export var delay: float = 1 ##time between each spawn of said collectable


@onready var spawnerTimer = $Timer

signal addCollectable;

func _ready():
	spawnerTimer.wait_time = delay

func activate():
	spawnerTimer.start();

func deactivate():
	spawnerTimer.stop();


func _on_timer_timeout():
	var Crystal: Object = CrystalScene.instantiate()
	var radius: float = randf_range(600, 1000)  
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	Crystal.position = Vector2(x, y)  + playerPos
	addCollectable.emit(Crystal)
