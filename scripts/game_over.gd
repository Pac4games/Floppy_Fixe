extends CanvasLayer

@onready var score_label:Label = $ScoreLabel
@onready var game_over_label:Label = $GameOverLabel

signal restart

func display_scores(score:int, highscore:int) -> void:
	if (score < highscore):
		game_over_label.text = "Oops, try again!"
		score_label.text = str(highscore)
	else:
		game_over_label.text = "New record! Can you do better though?"
		score_label.text = str(score)

func _on_restart_button_pressed() -> void:
	restart.emit()
