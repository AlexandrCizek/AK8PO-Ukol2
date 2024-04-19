class_name GameOver extends CanvasLayer

@onready var score_label: Label = %ScoreLabel
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton

func set_score(score: int):
	score_label.text = "Score: " + str(score)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
	
func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
