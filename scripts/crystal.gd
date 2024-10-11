extends Area2D

@export var pointsForCollecting: int = 1000;

func _on_body_entered(player: Player):
	print("in crystal")
	GlobalSignals.ModifyPlayerScore.emit(pointsForCollecting)
	
	player.startSuperDash();
	queue_free()
