extends ProgressBar

var reload_value: int = 0;
@onready var reloadCooldown = $ReloadCooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	value = (reloadCooldown.wait_time - reloadCooldown.time_left)*100;


func _on_visibility_changed():
	if self.visible == true:
		reloadCooldown.start()
	else: 
		value = 0;

