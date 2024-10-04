
extends CharacterBody2D

class_name Player

@onready var dash_cooldown = $DashCooldown
@onready var shape = %Sprite
@onready var health_text = $HealthText
@onready var invincibilty_border = $InvincibiltyBorder
@onready var i_frames_duration = $"I-FramesDuration"
@onready var slash_duaration = $SlashDuaration
@onready var slash_area = $SlashArea
@onready var slash_cooldown = $SlashCooldown
@onready var ammo_reloading_duration = $AmmoReloadingDuration
@onready var progress_bar = $AmmoReloading

@export var player_bullet: PackedScene

#----PLAYER MODIFIERS
@export var regular_bullet_speed: int
@export var initialBulletAmmo: int
@export var playerHealth: float = 5
@export var playerSpeed: float = 600
@export var dashAmount: float = 300
@export var dashSpeed: float = 2000

signal gameOver;
signal createPlayerBullet;


#--------VAR
var isAlive: bool = false;
var canDashAgain: bool = true;
var moveDirection: Vector2
var dashMoveDirection: Vector2
var startingPosWhenDashed: Vector2
var isCurrentlyDashing: bool = false;
var hasInvincibleFrames: bool = false;
var isSlashing: bool = false
var isOnSlashCooldown: bool = false;
var isOnShootCooldown: bool = false;
var bulletAmmo: int;



# Called when the node enters the scene tree for the first time.
func _ready():
	bulletAmmo = initialBulletAmmo
	health_text.text = str(playerHealth);

func setIsAlive(expression: bool) -> void:
	isAlive = expression;

func setHP(HP):
	playerHealth = HP;
	health_text.text = str(playerHealth);

func getHP() -> float:
	return playerHealth;

func taken_damage(damageTaken: float):
	
	if hasInvincibleFrames: return
	
	playerHealth -= damageTaken;
	health_text.text = str(playerHealth);
	hasInvincibleFrames = true;
	invincibilty_border.visible = true;
	i_frames_duration.start()

func getSlashStatus() -> bool:
	return isSlashing;

func setSpeed(speed):
	playerSpeed = speed;

func setDashSpeed(speed):
	dashSpeed = speed

func getDashStatus() -> bool:
	return isCurrentlyDashing;

func setDashAmount(amount: float) -> void:
	dashAmount = amount;

func getDashAmount():
	return dashAmount

func getAmmoReloadingDuration() -> float:
	return ammo_reloading_duration.wait_time

func _input(event) -> void:
	if !isAlive:
		return
	if !isCurrentlyDashing:
		if (event.is_action_pressed("Slash") and !isOnSlashCooldown and !isSlashing):
			player_slash()
		elif (event.is_action_pressed("Shoot") and !isOnShootCooldown):
			print("shoot")
			player_shoot()
			if bulletAmmo <= 0:
				print("reloading")
				isOnShootCooldown = true;
				progress_bar.visible = true;
				ammo_reloading_duration.start()

func player_slash():
	isSlashing = true;
	slash_area.monitorable = true
	slash_duaration.start()

func reload_ammo():
	isOnShootCooldown = false;
	bulletAmmo = initialBulletAmmo;
	progress_bar.visible = false;

func player_shoot() ->void:
	var newPlayerBullet = player_bullet.instantiate()
	var mousePos: Vector2 = get_global_mouse_position()
	var bulletDirection: float = (mousePos - self.position).angle()
	#setting the direction and position of the bullet
	newPlayerBullet.position = self.position
	newPlayerBullet.setDirection(bulletDirection);
	newPlayerBullet.setSpeed(regular_bullet_speed); #setting speed
	newPlayerBullet.setStarterPos(position) #keeping track of where the bullet got created.
	createPlayerBullet.emit(newPlayerBullet);
	
	bulletAmmo-=1;

func _physics_process(delta) -> void:
	#disables the player inputs if the player is dead
	if !isAlive:
		return
	if playerHealth <= 0:
		isAlive = false;
		visible = false;
		i_frames_duration.stop()
		
		gameOver.emit()
		return;
	
	if getSlashStatus() == true:
		var listOfEnemies: Array = slash_area.get_overlapping_areas()
		
		for Enemy in listOfEnemies:
			if Enemy.is_in_group("EnemyHitbox"):
				Enemy.got_slashed_by_player()
			
	
	health_text.text = str(playerHealth);
	
	#lets the player move if the cube isn't dashing, otherwise only let them dash
	if !isCurrentlyDashing:
		if (Input.is_action_pressed("MoveLeft")):
			position.x -= playerSpeed*delta;
			moveDirection += Vector2(-1,0)
		if (Input.is_action_pressed("MoveRight")):
			position.x += playerSpeed*delta;
			moveDirection += Vector2(1,0)
		if (Input.is_action_pressed("MoveUp")):
			position.y -= playerSpeed*delta;
			moveDirection += Vector2(0,-1)
		if (Input.is_action_pressed("MoveDown")):
			position.y += playerSpeed*delta;
			moveDirection += Vector2(0,1)
	else: while_dashing(delta)
	
	#if the player wants to dash and they 'can', let them
	if (Input.is_action_just_pressed("Dash") and canDashAgain and moveDirection != Vector2(0,0)):
		player_starts_dashing();
	
	moveDirection = Vector2(0,0); #resets the direction the player is moving towards (used for dashes)

func player_starts_dashing() ->void:
	change_brightness(2.5)
	shape.size.y = 30
	shape.position.y += 5;
	dashMoveDirection = moveDirection;
	isCurrentlyDashing = true;
	startingPosWhenDashed = position;
	canDashAgain = false;
	dash_cooldown.start() #have a cooldown between the current and the next dash

func while_dashing(delta) -> void:
	position += dashMoveDirection*dashSpeed*delta; #dash movement
	if position.distance_to(startingPosWhenDashed) > dashAmount: #if the player reached a certain distance, make them stop dashing
		change_brightness(1/2.5)
		shape.size.y = 40
		shape.position.y -= 5;
		isCurrentlyDashing = false;
		dashMoveDirection = Vector2(0,0)


func _on_dash_cooldown_timeout():
	canDashAgain = true;


func _on_i_frames_duration_timeout():
	hasInvincibleFrames = false;
	invincibilty_border.visible = false;

func change_brightness(brightness_factor: float):
	var current_modulate = modulate
	modulate = Color(current_modulate.r * brightness_factor, current_modulate.g * brightness_factor, current_modulate.b * brightness_factor, current_modulate.a)


func _on_slash_duaration_timeout():
	isSlashing = false;
	slash_area.monitorable = false
	
	isOnSlashCooldown = true;
	slash_cooldown.start()


func _on_slash_cooldown_timeout():
	isOnSlashCooldown = false;


func _on_ammo_reloading_duration_timeout():
	reload_ammo()
