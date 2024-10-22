extends Spawner
class_name EnvironmentBulletSpawner

signal addBullet;

@export var DamageDealing: float;
@export var lifespan: float;
@export var speed: float;
@export var warningSignDuration: float
@export var rotationSpeed: float
@export var randomizeSpawnOfBulletInACircle_RANGE: Array[float] = [0,0]

var trackPreviousBulletLocation: Vector2;
var distanceFromPreviousBullet: Vector2 = Vector2(0,0);

@onready var warningBulletLifespan = $warningBulletLifespan
var canBulletSpawn: bool = true; #currently not used

func _ready() -> void:
	super._ready()
	if warningBulletLifespan: warningBulletLifespan.wait_time = warningSignDuration

func setProperties(bullet: EnviornmentBullet) -> void:
	bullet.DamageDealing = DamageDealing
	bullet.lifespan = lifespan
	bullet.speed = speed
	if rotationSpeed != null and rotationSpeed != 0: #if the bullet has a rotation speed property, assign it to the new bullet
		bullet.call("setRotationSpeed",rotationSpeed)

func warningBulletCreation(bullet: EnviornmentBullet,brightness_factor: float) -> void:
	#the following actions are for the visual warning that the bullet will spawn - so we spawn two bullets, which the first one will not actually damage you.
	#only the second one will, however it will be created later.
	bullet.collision_layer = 0;
	var current_modulate = bullet.modulate
	bullet.modulate = Color(current_modulate.r * brightness_factor, current_modulate.g * brightness_factor, current_modulate.b * brightness_factor, current_modulate.a)
	bullet.set_z_index(-10) 
	addBullet.emit(bullet,bullet.lifespan)#add the warning bullet alert, its lifespan will be the time it takes till the actual bullet spawns

func randomizeSpawnOfBulletInACircle(radiusRange: Array[float]) -> Vector2:
	var radius: float = randf_range(radiusRange[0], radiusRange[1]) 
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	return Vector2(x,y)
