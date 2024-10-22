extends EnvironmentBulletSpawner

@export var TheThinLine: PackedScene

var brightnessFactor = 0.4


func _on_spawning_cooldown_timeout() -> void:
	var bullet: EnviornmentBullet = TheThinLine.instantiate()

	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	var randomizedLocationRelativeToPlayer: Vector2 = randomizeSpawnOfBulletInACircle([randomizeSpawnOfBulletInACircle_RANGE[0],randomizeSpawnOfBulletInACircle_RANGE[1]]) + playerPos
	bullet.position = randomizedLocationRelativeToPlayer
	bullet.rotation = randf_range(0,360)
	
	warningBulletCreation(bullet,brightnessFactor)
	bulletFadeInDuration(bullet)#this handles making the bullet a threat and spawning it where the fake bullet was

func bulletFadeInDuration(bullet: EnviornmentBullet) -> void:
	var newBullet: EnviornmentBullet = TheThinLine.instantiate()
	setProperties(newBullet)
	newBullet.position = bullet.position
	newBullet.rotation = bullet.rotation
	
	await get_tree().create_timer(warningBulletLifespan.wait_time).timeout
	addBullet.emit(newBullet,lifespan)#add the real bullet
