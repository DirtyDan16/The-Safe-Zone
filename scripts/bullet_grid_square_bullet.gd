extends EnviornmentBullet

@export var gridSquareBulletLength: float = 100
var baseSize : float = 100;

func _ready():
	var Scale : float = gridSquareBulletLength/baseSize
	scale = Vector2(Scale,Scale)
