extends Area2D

signal collect

func _on_body_entered(body):
	if "Player" == body.get_name():
		var collected_coin = self
		emit_signal("collect", collected_coin)
