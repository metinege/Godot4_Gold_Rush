extends Area2D

signal death

func _on_body_entered(body):
	if "Player" == body.get_name():
		emit_signal("death")
