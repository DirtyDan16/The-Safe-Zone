extends Area2D


signal changeBrightness
signal moveEnemyTowardsPlayer


@onready var checkDelay = %CheckForIsHomingDelay

@export var scaleOfArea: Vector2 = Vector2(1,1);

#--------------VAR
var isHoming : bool = false;
var player: Player

func _ready():
	scale = scaleOfArea;

func _on_body_entered(body) -> void:
	if !body is Player: return
	
	player = body as Player
	
	isHoming = true;
	changeBrightness.emit(1.75)
	
	checkDelay.start()#checks every tick if the player is still whithin the range of the enemy
	


func _on_body_exited(body) -> void:
	if !body.is_in_group("Player"):
		return
	
	isHoming = false;
	changeBrightness.emit(1/1.75)

func _on_check_for_is_homing_delay_timeout():
	if !isHoming: 
		checkDelay.stop()
		return;
	moveEnemyTowardsPlayer.emit(player)
