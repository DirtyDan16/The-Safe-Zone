extends Area2D

signal collidedWithPlayer
signal gotShotByBullet

func _on_body_entered(body):
	if !body.is_in_group("Player") or body.getDashStatus():
		return
	
	collidedWithPlayer.emit(body)


func got_slashed_by_player():
	get_parent().queue_free()


func _on_area_entered(area):
	if area is PlayerBullets:
		area.queue_free()
		gotShotByBullet.emit(area.getDamageValue())

