extends Node2D

@export var TheThinLine: PackedScene

@export var delay: float = 0.2 ##time between each spawn of said bullet

@onready var spawnerTimer = $DelayBetweenBulletSpawning
@onready var bullet_fade_in_timer = $BulletFadeInTimer



var canBulletSpawn: bool = false;
var brightness_factor = 0.4

signal addBullet;

func _ready() -> void:
	spawnerTimer.wait_time = delay
	var bullet: EnviornmentBullet = TheThinLine.instantiate()
	bullet_fade_in_timer.wait_time = bullet.FADE_IN_DURATION

func activate() -> void:
	spawnerTimer.start();

func deactivate() -> void:
	spawnerTimer.stop();


func _on_delay_between_bullet_spawning_timeout() -> void:
	var bullet: EnviornmentBullet = TheThinLine.instantiate()
	#gives the bullet a random position based on a grid like formation

	var radius: float = randf_range(400, 1000) 
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	
	bullet.position = Vector2(x, y)  + playerPos
	bullet.rotation = randf_range(0,360)
	
	warningBulletCreation(bullet)
	bulletFadeInDuration(bullet)#this handles making the bullet a threat and spawning it where the fake bullet was

func warningBulletCreation(bullet: EnviornmentBullet) -> void:
	#the following actions are for the visual warning that the bullet will spawn - so we spawn two bullets, which the first one will not actually damage you.
	#only the second one will, however it will be created later.
	bullet.collision_layer = 0;
	var current_modulate = bullet.modulate
	bullet.modulate = Color(current_modulate.r * brightness_factor, current_modulate.g * brightness_factor, current_modulate.b * brightness_factor, current_modulate.a)
	bullet.set_z_index(-10) 
	addBullet.emit(bullet,bullet_fade_in_timer.wait_time)#add the warning bullet alert, its lifespan will be the time it takes till the actual bullet spawns

func bulletFadeInDuration(bullet: EnviornmentBullet) -> void:
	var newBullet: EnviornmentBullet = TheThinLine.instantiate()
	newBullet.position = bullet.position
	newBullet.rotation = bullet.rotation
	
	await get_tree().create_timer(bullet_fade_in_timer.wait_time).timeout
	addBullet.emit(newBullet,newBullet.lifespan)#add the real bullet

