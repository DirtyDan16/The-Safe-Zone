extends Area2D

@export var pointsForCollecting: int = 200;
@export var lifespan: float = 90;
@export var radiusOfSpawnRange: Array[float] = [600,1000]

func _on_body_entered(body: PhysicsBody2D):
	if !body is Player: return
	var player: Player = body as Player
	GlobalSignals.ModifyPlayerScore.emit(pointsForCollecting)
	
	player.startSuperDash();
	queue_free()
