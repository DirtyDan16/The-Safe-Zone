extends Spawner
class_name EnvironmentBulletSpawner

signal addBullet;

@export var DamageDealing: float;
@export var lifespan: float;
@export var speed: float;
@export var warningSignDuration: float

func _ready() -> void:
	super._ready()
	if get_node("bullet_fade_in_timer"):
		get_node("bullet_fade_in_timer").wait_time = get("warningSignDuration")

func setProperties(bullet: EnviornmentBullet) -> void:
	bullet.DamageDealing = DamageDealing
	bullet.lifespan = lifespan
	bullet.speed = speed

func warningBulletCreation(bullet: EnviornmentBullet,brightness_factor: float) -> void:
	#the following actions are for the visual warning that the bullet will spawn - so we spawn two bullets, which the first one will not actually damage you.
	#only the second one will, however it will be created later.
	bullet.collision_layer = 0;
	var current_modulate = bullet.modulate
	bullet.modulate = Color(current_modulate.r * brightness_factor, current_modulate.g * brightness_factor, current_modulate.b * brightness_factor, current_modulate.a)
	bullet.set_z_index(-10) 
	addBullet.emit(bullet,lifespan)#add the warning bullet alert, its lifespan will be the time it takes till the actual bullet spawns
