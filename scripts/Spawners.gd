extends Node2D
class_name Spawner

@onready var spawningCooldownTimer = $spawningCooldown
@export var delay: float

func _ready():
	spawningCooldownTimer.set_wait_time(delay)

func activate():
	spawningCooldownTimer.start();

func deactivate():
	spawningCooldownTimer.stop();

func addInstance():
	call("_on_spawning_cooldown_timeout") 
