extends Area2D
class_name EnviornmentBullet

@export var DamageDealing: float;
@export var lifespan: float;
@export var speed: float;
@export var warningSignDuration: float
@export var rotatingSpeed: float;
@export var isWarningBullet: bool = true

func setRotationSpeed(speed: float) -> void:
	rotatingSpeed = speed
