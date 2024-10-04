extends Label

var score: int = 0;

var isScoreModifiable: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.StopScore.connect(Callable(self,"finaliseScore"))
	GlobalSignals.ModifyPlayerScore.connect(Callable(self,"modifyScore"));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_gui_start_scoring_counter():
	isScoreModifiable = true;
	$SurvivalPointsCooldown.start()

func modifyScore(scoreAmount: int):
	score+=scoreAmount
	text = "SCORE: "+str(score);

func _on_survival_points_cooldown_timeout():
	score+=10;
	text = "SCORE: "+str(score);

func finaliseScore():
	isScoreModifiable = false;
	$SurvivalPointsCooldown.stop()
