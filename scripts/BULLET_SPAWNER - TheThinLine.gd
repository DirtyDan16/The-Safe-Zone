extends EnvironmentBulletSpawner

@export var TheThinLine: PackedScene

@onready var bullet_fade_in_timer = $BulletFadeInTimer

var canBulletSpawn: bool = false;
var brightnessFactor = 0.4


func _on_spawning_cooldown_timeout() -> void:
	var bullet: EnviornmentBullet = TheThinLine.instantiate()
	#gives the bullet a random position based on a grid like formation

	var radius: float = randf_range(400, 1000) 
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	
	bullet.position = Vector2(x, y)  + playerPos
	bullet.rotation = randf_range(0,360)
	
	warningBulletCreation(bullet,brightnessFactor)
	bulletFadeInDuration(bullet)#this handles making the bullet a threat and spawning it where the fake bullet was

func bulletFadeInDuration(bullet: EnviornmentBullet) -> void:
	var newBullet: EnviornmentBullet = TheThinLine.instantiate()
	setProperties(newBullet)
	newBullet.position = bullet.position
	newBullet.rotation = bullet.rotation
	
	await get_tree().create_timer(bullet_fade_in_timer.wait_time).timeout
	addBullet.emit(newBullet,lifespan)#add the real bullet
