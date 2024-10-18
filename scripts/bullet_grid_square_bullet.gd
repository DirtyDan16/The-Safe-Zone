extends EnviornmentBullet

@export var GRID_SQUARE_BULLET_LENGTH: float = 100
var baseSize : float = 100;

func _ready():
	var Scale : float = GRID_SQUARE_BULLET_LENGTH/baseSize
	scale = Vector2(Scale,Scale)
