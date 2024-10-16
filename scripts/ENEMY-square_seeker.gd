extends Enemy

signal collidedWithPlayer


func change_brightness(brightness_factor: float):
	var current_modulate = modulate
	modulate = Color(current_modulate.r * brightness_factor, current_modulate.g * brightness_factor, current_modulate.b * brightness_factor, current_modulate.a)


func _on_homing_move_enemy_towards_player(player: Player) -> void:
	position += (player.position - position).normalized() * speed


func _on_hitbox_collided_with_player(player: Player) -> void:
	player.taken_damage(damageOnContact);
	collidedWithPlayer.emit()
	queue_free()


func _on_enemy_hitbox_component_got_shot_by_bullet(damageTaken: float):
	health -= damageTaken;
	if health <= 0:
		GlobalSignals.ModifyPlayerScore.emit(scoreForEliminating)
		queue_free()
