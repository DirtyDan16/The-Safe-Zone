extends EnvironmentBulletSpawner

@export var TheRotatingCross: PackedScene

var brightnessFactor = 0.4
var minDistanceBetweenTwoTimeAdjacentBullets: float = 500;

func _on_spawning_cooldown_timeout() -> void:
	var bullet: EnviornmentBullet = TheRotatingCross.instantiate() as EnviornmentBullet

	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	var randomizedLocationRelativeToPlayer: Vector2 = randomizeSpawnOfBulletInACircle([randomizeSpawnOfBulletInACircle_RANGE[0],randomizeSpawnOfBulletInACircle_RANGE[1]]) + playerPos
	if trackPreviousBulletLocation != null: 
		while trackPreviousBulletLocation.distance_to(randomizedLocationRelativeToPlayer) < minDistanceBetweenTwoTimeAdjacentBullets:
			randomizedLocationRelativeToPlayer = randomizeSpawnOfBulletInACircle([randomizeSpawnOfBulletInACircle_RANGE[0],randomizeSpawnOfBulletInACircle_RANGE[1]]) + playerPos
	bullet.position = randomizedLocationRelativeToPlayer
	trackPreviousBulletLocation = bullet.position 
	bullet.rotation = randf_range(0,360)
	bullet.lifespan = warningSignDuration #the lifespan of the warning bullet is the amount of time it is gonna alert
	
	warningBulletCreation(bullet,brightnessFactor)
	bulletFadeInDuration(bullet)#this handles making the bullet a threat and spawning it where the fake bullet was

func bulletFadeInDuration(bullet: EnviornmentBullet) -> void:
	var newBullet: EnviornmentBullet = TheRotatingCross.instantiate()
	setProperties(newBullet)
	newBullet.position = bullet.position
	newBullet.rotation = bullet.rotation
	newBullet.isWarningBullet = false;
	
	await get_tree().create_timer(warningBulletLifespan.wait_time).timeout
	addBullet.emit(newBullet,lifespan)#add the real bullet
