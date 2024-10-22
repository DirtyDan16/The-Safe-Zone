extends EnvironmentBulletSpawner

@export var bulletScene: PackedScene

var brightnessFactor = 0.4

func _on_spawning_cooldown_timeout() -> void:
	var bullet: EnviornmentBullet = bulletScene.instantiate() as EnviornmentBullet
	setProperties(bullet)
	#gives the bullet a random position based on a grid like formation
	var xPos: int = randi_range(-10,10)  
	var yPos: int = randi_range(-5,5)
	var playerPos : Vector2 = floor(get_tree().current_scene.get_player_pos()/bullet.gridSquareBulletLength); #we want the player pos wounded down so its position will fit in the grid we created
	bullet.position = Vector2(xPos, yPos)*bullet.gridSquareBulletLength + playerPos*bullet.gridSquareBulletLength #the posiiton of the bullet will be relative to the palyer
	
	warningBulletCreation(bullet,brightnessFactor)
	bulletFadeInDuration(bullet)#this handles making the bullet a threat and spawning it where the fake bullet was

func bulletFadeInDuration(bullet: EnviornmentBullet) -> void:
	var newBullet: EnviornmentBullet = bulletScene.instantiate() as EnviornmentBullet
	setProperties(newBullet)
	newBullet.position = bullet.position
	print(newBullet.DamageDealing)
	await get_tree().create_timer(warningBulletLifespan.wait_time).timeout
	addBullet.emit(newBullet,lifespan)#add the real bullet
