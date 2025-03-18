extends Node2D

var score_p1 = 0:
	set(value):
		score_p1 = value
		$Score_P1.text = str(value)

var score_p2 = 0:
	set(value):
		score_p2 = value
		$Score_P2.text = str(value)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_game"):
		score_p1 = 0
		score_p2 = 0
		get_tree().reload_current_scene()

func _ready():
	$Ball.launch_at_random_direction()
	$Ball.scored.connect(_on_scored)

func _on_scored(p: String):
	if p == "p1":
		score_p1 += 1
	if p == "p2":
		score_p2 += 1
