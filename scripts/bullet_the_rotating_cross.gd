extends EnviornmentBullet

func _process(delta: float) -> void:
	if isWarningBullet: return #start rotating only if it is an actual bullet and not a warning bullet
	rotation += rotatingSpeed*delta;
