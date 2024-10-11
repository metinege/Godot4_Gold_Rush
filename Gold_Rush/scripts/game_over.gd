extends Control

@onready var your_score_label = $VBoxContainer/YourScoreLabel

func _ready():
	your_score_label.text = "Your score: " + str(Singleton.coin_count)
	
	if Singleton.game_timer > 0:
		$VBoxContainer/GameOverMessageLabel.text = "Bats are surpassed you!"
	else:
		$VBoxContainer/GameOverMessageLabel.text = "Time is up!"

func _on_try_again_button_pressed():
	Singleton.game_timer = 30
	Singleton.coin_count = 0
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_pressed():
	get_tree().quit()
