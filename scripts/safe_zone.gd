extends RigidBody2D


@onready var outline = %OutlineOfSafeZone

#-----------VAR
var moveDirection: Vector2;
var velocity = Vector2(0,0)
var bounce_factor = 0.8

func changeMoveDirectionVector(minRadius: float,maxRadius: float) -> void:
	var radius: float = randf_range(minRadius, maxRadius)  # Random radius between 0 and 1
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	velocity = Vector2(x, y)


func _ready() -> void:
	var SAFE_ZONE_SIZE: float = self.get_meta("size")
	
	position += moveDirection
	
	
	gravity_scale = 0  # This removes gravity effect
	
	
	# Set the scale of the Sprite to match the radius
	if SAFE_ZONE_SIZE > 0:
		# Calculate scale factor based on texture size
		var texture_size = outline.texture.get_size().x * outline.scale.x
		var scale_factor = SAFE_ZONE_SIZE / texture_size
		$CollisionShape2D.scale = Vector2(scale_factor, scale_factor)
		outline.scale  = Vector2(scale_factor, scale_factor)

func zone_physics_process(delta) -> void:
	
	# Move the safezone
	var collision := move_and_collide(velocity * delta)
	if collision:
		handle_collision(collision)

func handle_collision(collision: KinematicCollision2D) -> void:
	var collider := collision.get_collider()
	var normal := collision.get_normal()
	
	if collider in get_tree().get_nodes_in_group("SafeZones"):
		# Elastic collision with another SafeZone
		var relative_velocity = velocity - collider.velocity
		var impulse = -2 * relative_velocity.dot(normal) / (1 + 1) * normal  # Assuming equal mass
		velocity += impulse
		collider.velocity -= impulse
	else:
		# Simple bounce off other objects
		velocity = velocity.bounce(normal) * bounce_factor
