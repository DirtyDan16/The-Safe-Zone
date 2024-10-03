extends ProgressBar

var reload_value: int = 0;
@onready var reloadCooldown = $ReloadCooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = (reloadCooldown.wait_time - reloadCooldown.time_left)*100;


func _on_visibility_changed():
	if self.visible == true:
		reloadCooldown.start()
	else: 
		value = 0;

