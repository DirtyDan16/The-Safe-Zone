extends Node2D

@export var SquareSeeker: PackedScene
@export var ENEMY_SQUARE_SEEKER_MIN_SPEED: float = 1
@export var ENEMY_SQUARE_SEEKER_MAX_SPEED: float = 1;
@export var delay: float = 1 ##time between each spawn of said enemy


@onready var spawnerTimer = $SquareSeekerSpawner

signal addEnemy;

func _ready():
	spawnerTimer.wait_time = delay

func activate():
	spawnerTimer.start();

func deactivate():
	spawnerTimer.stop();

func _on_square_seeker_spawner_timeout() -> void:
	#print("enemy spawn")
	var Enemy: Object = SquareSeeker.instantiate();
	var radius: float = randf_range(400, 700)  
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_parent().get_player_pos()
	
	Enemy.position = Vector2(x, y)  + playerPos
	Enemy.setSpeed(ENEMY_SQUARE_SEEKER_MIN_SPEED,ENEMY_SQUARE_SEEKER_MAX_SPEED);
	addEnemy.emit(Enemy)
