extends Enemy

signal collidedWithPlayer

var player: Player

@export var wiggleMovementSpeed: float = 20.0   # Speed of the reciprocating motion
@export var wiggleLength: float = 8.0     # Max wiggleLength for reciprocating motion

var axisOfWiggleMovement: Vector2
var offsetFromTheMiddleOfTheWiggleMovement: float = 0.0
var wiggleDirection: float = 1.0  # Reciprocating direction (1 = forward, -1 = backward)


##obtaining the player node so we can track its position
func initialize(target_player: Player):
	player = target_player

func _process(delta: float):
	if !player.isAlive: 
		set_process(false)
		return
# Calculate the direction to the player
	var directionToPlayer: Vector2 = Vector2(player.position - position).normalized()
	#-------------print(directionToPlayer)

# Calculate the perpendicular direction (rotate by 90 degrees)
	axisOfWiggleMovement = Vector2(-directionToPlayer.y, directionToPlayer.x)

# Update the offset for reciprocating motion along the perpendicular direction
	offsetFromTheMiddleOfTheWiggleMovement += wiggleMovementSpeed * delta * wiggleDirection

# If the offset exceeds the wiggleLength, reverse the direction
	if offsetFromTheMiddleOfTheWiggleMovement > wiggleLength: wiggleDirection = -1.0  # Reverse direction
	elif offsetFromTheMiddleOfTheWiggleMovement < -wiggleLength: wiggleDirection = 1.0   # Move forward
	
	 # Apply the reciprocating motion along the perpendicular direction
	var reciprocatingMotion: Vector2 = axisOfWiggleMovement * offsetFromTheMiddleOfTheWiggleMovement
	 # Progressive movement towards the player
	var progressiveMotion: Vector2 = directionToPlayer * speed * delta
	
# Update the node's position based on the perpendicular direction
	position += reciprocatingMotion + progressiveMotion #MOVEMENT
	rotation = (player.position - position).angle()

func _on_enemy_hitbox_component_got_shot_by_bullet(damageTaken: float):
	health -= damageTaken;
	if health <= 0:
		GlobalSignals.ModifyPlayerScore.emit(scoreForEliminating)
		queue_free()

func _on_enemy_hitbox_component_collided_with_player(thePlayer: Player) -> void:
	thePlayer.taken_damage(damageOnContact);
	collidedWithPlayer.emit()
	queue_free()
