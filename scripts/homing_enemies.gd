extends Area2D


signal changeBrightness
signal moveEnemyTowardsPlayer


@onready var checkDelay = %CheckForIsHomingDelay


#--------------VAR
var isHoming : bool = false;


func _ready():
	pass

func _on_body_entered(body) -> void:
	if !body.is_in_group("Player"):
		return
	
	isHoming = true;
	changeBrightness.emit(1.75)
	
	while true:
		if !isHoming: return;
		checkDelay.start()
		await checkDelay.timeout
		moveEnemyTowardsPlayer.emit(body)


func _on_body_exited(body) -> void:
	if !body.is_in_group("Player"):
		return
	
	isHoming = false;
	changeBrightness.emit(1/1.75)
