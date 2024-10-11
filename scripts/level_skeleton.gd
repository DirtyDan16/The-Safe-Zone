extends Node2D

@onready var start_level_button = $GUI/StartLevelButton
@onready var reset_level_button = $GUI/ResetLevelButton
@onready var player = %Player
@onready var safe_zones_movement_timer = $SafeZonesChangeDirectionDelay
@onready var list_of_enemy_spawners = $ListOfEnemySpawners
@onready var list_of_collectable_spawners = $ListOfCollectableSpawners
@onready var list_of_bullet_hell_projectiles = $ListOfBulletHellProjectiles

var enemySpawners: Array[Node]
var collectableSpawners: Array[Node];
var bulletHellProjectiles: Array[Node];


#---GAME MODIFIERS:
var SAFE_ZONE_SIZE: float
var SAFE_ZONE_MIN_SPEED: float
var SAFE_ZONE_MAX_SPEED: float

#--------VAR
var gameAlive: bool = false;


func _on_gui_start_game() -> void:
	game_start();

func game_start() -> void:

	gameAlive = true;
	player.setIsAlive(true);
	
	#start safezones' movements
	_on_safe_zones_change_direction_delay_timeout()
	safe_zones_movement_timer.start()
	

func game_over() -> void:
	GlobalSignals.StopScore.emit()
	print("game over")
	reset_level_button.visible = true;

func _physics_process(delta) -> void:
	if !gameAlive: return;
	
	var safeZones: Array = get_tree().get_nodes_in_group("SafeZones");
	for safeZone in safeZones:
		safeZone.zone_physics_process(delta)

func _on_safe_zones_change_direction_delay_timeout():
	var safeZones: Array = get_tree().get_nodes_in_group("SafeZones");
	for safeZone in safeZones:
		safeZone.changeMoveDirectionVector(SAFE_ZONE_MIN_SPEED,SAFE_ZONE_MAX_SPEED);

func add_enemy(Enemy: Object) -> void:
	add_child(Enemy)

func add_collectable(Collectable: Object) -> void:
	add_child(Collectable)

func add_bullet(Bullet: Object,lifespan: float) -> void:
	add_child(Bullet)
	await get_tree().create_timer(lifespan).timeout
	Bullet.queue_free()

func _on_player_cerate_player_bullet(bullet: PlayerBullets):
	#print("got to func: _on_player_cerate_player_bullet")
	add_child(bullet);

func get_player_pos() -> Vector2:
	return player.position
