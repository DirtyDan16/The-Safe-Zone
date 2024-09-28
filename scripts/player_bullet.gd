extends Area2D
class_name PlayerBullets

var speed: float = 800;
var damage: float = 1;
var bulletDirection: float;
var START_POS: Vector2;
var BULLET_RANGE: float;

func _ready():
	BULLET_RANGE = get_meta("bullet_range");

func setSpeed(SPEED: float) -> void:
	speed = SPEED;

func getDamageValue() -> float:
	return damage;

func setDirection(direction: float):
	bulletDirection = direction;

func setStarterPos(start: Vector2) -> void:
	START_POS = start;

func _process(delta) -> void:
	position.x += speed*delta*cos(bulletDirection);
	position.y += speed*delta*sin(bulletDirection);
	if self.position.distance_to(START_POS) > BULLET_RANGE: queue_free()
