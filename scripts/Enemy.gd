extends Node2D
class_name Enemy

#------CONST
@export var speed: float = 3
@export var damageOnContact: float = 1
@export var scoreForEliminating: int = 10
@export var health: float = 4;


func setSpeed(minSpeed,maxSpeed) -> void:
	speed = randf_range(minSpeed,maxSpeed)
