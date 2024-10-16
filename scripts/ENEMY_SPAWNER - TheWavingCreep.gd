extends Spawner

@export var EnemyScene: PackedScene
@export var enemySpeedRandomRange: Vector2 = Vector2(3,7)
@export var enemySpawnInRadiusRandomRange: Vector2 = Vector2(1000,1400)

var player: Player

func _ready():
	super._ready()
	player = %Player

signal addEnemy;



func _on_spawning_cooldown_timeout() -> void:
	#print("enemy spawn")
	var enemy: Enemy = EnemyScene.instantiate();
	var radius: float = randf_range(enemySpawnInRadiusRandomRange[0], enemySpawnInRadiusRandomRange[1])  
	var angle: float = randf_range(0, 2 * PI)  # Random angle between 0 and 2π
	var x: float = radius * cos(angle)
	var y: float = radius * sin(angle)
	var playerPos : Vector2 = get_tree().current_scene.get_player_pos();
	
	enemy.position = Vector2(x, y)  + playerPos
	enemy.setSpeed(enemySpeedRandomRange[0],enemySpeedRandomRange[1]);
	enemy.initialize(player) #giving the enemy the knowledge of the player node so it can track it
	addEnemy.emit(enemy)
