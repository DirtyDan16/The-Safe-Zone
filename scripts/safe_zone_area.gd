extends Area2D

@onready var out_of_zone_taking_damage_delay = %OutOfZoneTakingDamageDelay


func _on_body_exited(body: Player) -> void:
	if body.getDashStatus() == false:
		body.taken_damage(1);
	else: 
		while true: #this is a checker for if the player is still invincible via dashing
			await get_tree().create_timer(0.02).timeout
			if body.getDashStatus() == false:
				_on_out_of_zone_taking_damage_delay_timeout()
				break;
		 
	out_of_zone_taking_damage_delay.start()


func _on_out_of_zone_taking_damage_delay_timeout() -> void:
	var player: Object = get_tree().get_first_node_in_group("Player")
	if player == null:
		print("PLayer's dead/not found")
		return
	
	
	var SafeZones: Array = get_tree().get_nodes_in_group("SafeZones")
	for SafeZone in SafeZones:
		for shape in SafeZone.get_node("DetectionArea").get_overlapping_bodies():
			if shape == player: return
	
	player.taken_damage(1); 
	#print("Player's HP is: ",Player.getHP());
	out_of_zone_taking_damage_delay.start()

signal borderCollided;

func _on_area_entered(area):
	if area.is_in_group("Borders") or area.is_in_group("SafeZones"):
		borderCollided.emit()
