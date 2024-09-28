
extends CharacterBody2D

class_name Player

@onready var dash_cooldown = $DashCooldown
@onready var shape = %ColorRect
@onready var health_text = $HealthText
@onready var invincibilty_border = $InvincibiltyBorder
@onready var i_frames_duration = $"I-FramesDuration"
@onready var slash_duaration = $SlashDuaration
@onready var slash_area = $SlashArea
@onready var slash_cooldown = $SlashCooldown

@export var player_bullet: PackedScene
@export var regular_bullet_speed: int

signal gameOver;
signal createPlayerBullet;

#---------CONST
var _MOVE_SPEED: float
var _DASH_SPEED: float
var _HP: float
var _DASH_AMOUNT: float

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


# Called when the node enters the scene tree for the first time.
func _ready():
	health_text.text = str(_HP);

func setIsAlive(expression: bool) -> void:
	isAlive = expression;

func setHP(HP):
	_HP = HP;
	health_text.text = str(_HP);

func getHP() -> float:
	return _HP;

func taken_damage(damageTaken: float):
	
	if hasInvincibleFrames: return
	
	_HP -= damageTaken;
	health_text.text = str(_HP);
	hasInvincibleFrames = true;
	invincibilty_border.visible = true;
	i_frames_duration.start()

func getSlashStatus() -> bool:
	return isSlashing;

func setSpeed(speed):
	_MOVE_SPEED = speed;

func setDashSpeed(speed):
	_DASH_SPEED = speed

func getDashStatus() -> bool:
	return isCurrentlyDashing;

func setDashAmount(amount: float) -> void:
	_DASH_AMOUNT = amount;

func getDashAmount():
	return _DASH_AMOUNT

func _input(event) -> void:
	if !isAlive:
		return
	if !isCurrentlyDashing:
		if (Input.is_action_just_pressed("Slash") and !isOnSlashCooldown and !isSlashing):
			player_slash()
		if (Input.is_action_just_pressed("Shoot") and !isOnShootCooldown):
			player_shoot()

func player_slash():
	isSlashing = true;
	slash_area.monitorable = true
	slash_duaration.start()

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

func _physics_process(delta) -> void:
	#disables the player inputs if the player is dead
	if !isAlive:
		return
	if _HP <= 0:
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
			
	
	health_text.text = str(_HP);
	
	#lets the player move if the cube isn't dashing, otherwise only let them dash
	if !isCurrentlyDashing:
		if (Input.is_action_pressed("MoveLeft")):
			position.x -= _MOVE_SPEED*delta;
			moveDirection += Vector2(-1,0)
		if (Input.is_action_pressed("MoveRight")):
			position.x += _MOVE_SPEED*delta;
			moveDirection += Vector2(1,0)
		if (Input.is_action_pressed("MoveUp")):
			position.y -= _MOVE_SPEED*delta;
			moveDirection += Vector2(0,-1)
		if (Input.is_action_pressed("MoveDown")):
			position.y += _MOVE_SPEED*delta;
			moveDirection += Vector2(0,1)
	else: while_dashing(delta)
	
	#if the player wants to dash and they 'can', let them
	if (Input.is_action_just_pressed("Dash") and canDashAgain and moveDirection != Vector2(0,0)):
		player_starts_dashing();
	
	moveDirection = Vector2(0,0); #resets the direction the player is moving towards (used for dashes)

func player_starts_dashing() ->void:
	#print("isCurrentlyDashing = ",isCurrentlyDashing)
	change_brightness(2.5)
	shape.size.y = 30
	shape.position.y += 5;
	dashMoveDirection = moveDirection;
	isCurrentlyDashing = true;
	startingPosWhenDashed = position;
	canDashAgain = false;
	dash_cooldown.start() #have a cooldown between the current and the next dash

func while_dashing(delta) -> void:
	#print("isCurrentlyDashing = ",isCurrentlyDashing)
	position += dashMoveDirection*_DASH_SPEED*delta; #dash movement
	if sqrt(pow(position.y - startingPosWhenDashed.y,2) +  
	   pow(position.x - startingPosWhenDashed.x,2)) > _DASH_AMOUNT: #if the player reached a certain distance, make them stop dashing
			change_brightness(1/2.5)
			shape.size.y = 40
			shape.position.y -= 5;
			isCurrentlyDashing = false;
			dashMoveDirection = Vector2(0,0)
			#print("isCurrentlyDashing = ",isCurrentlyDashing)

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