extends Node2D

@export var GridSquareBullet: PackedScene

@export var delay: float = 1 ##time between each spawn of said bullet

@onready var spawnerTimer = $DelayBetweenBulletSpawning
@onready var bullet_fade_in_timer = $BulletFadeInTimer



var canBulletSpawn: bool = false;
var brightness_factor = 0.4

signal addBullet;

func _ready() -> void:
	spawnerTimer.wait_time = delay
	var bullet: EnviornmentBullet = GridSquareBullet.instantiate()
	bullet_fade_in_timer.wait_time = bullet.FADE_IN_DURATION

func activate() -> void:
	spawnerTimer.start();

func deactivate() -> void:
	spawnerTimer.stop();


func _on_delay_between_bullet_spawning_timeout() -> void:
	var bullet: EnviornmentBullet = GridSquareBullet.instantiate()
	#gives the bullet a random position based on a grid like formation
	var xPos: int = randi_range(-10,10)  
	var yPos: int = randi_range(-5,5)
	var playerPos : Vector2 = floor(get_tree().current_scene.get_player_pos()/bullet.GRID_SQUARE_BULLET_LENGTH); #we want the player pos wounded down so its position will fit in the grid we created
	bullet.position = Vector2(xPos, yPos)*bullet.GRID_SQUARE_BULLET_LENGTH + playerPos*bullet.GRID_SQUARE_BULLET_LENGTH #the posiiton of the bullet will be relative to the palyer
	
	#the following actions are for the visual warning that the bullet will spawn - so we spawn two bullets, which the first one will not actually damage you.
	#only the second one will, however it will be created later.
	bullet.collision_layer = 0;
	var current_modulate = bullet.modulate
	bullet.modulate = Color(current_modulate.r * brightness_factor, current_modulate.g * brightness_factor, current_modulate.b * brightness_factor, current_modulate.a)
	bullet.set_z_index(-10) 
	addBullet.emit(bullet,bullet_fade_in_timer.wait_time)#add the warning bullet alert, its lifespan will be the time it takes till the actual bullet spawns
	
	bulletFadeInDuration(bullet,current_modulate)#this handles making the bullet a threat and spawning it where the fake bullet was


func bulletFadeInDuration(bullet: EnviornmentBullet,current_modulate) -> void:
	var newBullet: EnviornmentBullet = GridSquareBullet.instantiate()
	newBullet.position = bullet.position
	
	await get_tree().create_timer(bullet_fade_in_timer.wait_time).timeout
	addBullet.emit(newBullet,newBullet.lifespan)#add the real bullet

