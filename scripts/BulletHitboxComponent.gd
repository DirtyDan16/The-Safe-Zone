extends Area2D

signal collidedWithPlayer

func _on_body_entered(body):
	if !body.is_in_group("Player") or body.getDashStatus():
		return
	
	collidedWithPlayer.emit(body)
