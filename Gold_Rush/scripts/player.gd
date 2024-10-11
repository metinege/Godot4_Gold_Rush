extends CharacterBody2D

@export var speed: int = 500

func _process(_delta):
	var viewport_size : Vector2 = get_viewport_rect().size
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()
	
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < -0:
		$Sprite2D.flip_h = true
	
	position.x = clamp(position.x, 0, viewport_size.x)
	position.y = clamp(position.y, 0, viewport_size.y)
