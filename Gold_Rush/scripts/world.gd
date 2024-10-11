extends Node2D

@onready var coin_count_label = $UI/VBoxContainer/CoinCountLabel
@onready var time_left_label = $UI/VBoxContainer/TimeLeftLabel
@onready var coin_collect_sounds : Array = [
$Sounds/coin_collect_sound1, 
$Sounds/coin_collect_sound2, 
$Sounds/coin_collect_sound3
]

@export var disappear_time : int = 2
@export var game_timer : int = 30

var viewport_size : Vector2

func _ready():
	$Sounds/game_theme_music.play()

func _process(_delta):
	viewport_size = get_viewport_rect().size
	
	for coin in $SpawnedCoins.get_children():
		if coin is Area2D:
			if not coin.is_connected("collect", Callable(self, "_on_coin_collect")):
				coin.connect("collect", Callable(self, "_on_coin_collect"))
	
	for enemy in $SpawnedEnemies.get_children():
		if enemy is Area2D:
			if not enemy.is_connected("death", Callable(self,"_on_death")):
				enemy.connect("death", Callable(self, "_on_death"))
	
	coin_count_label.text = "Coins: " + str(Singleton.coin_count)
	time_left_label.text = "Time Left: " + str(Singleton.game_timer)

func _on_coin_collect(collected_coin):
	var sounds_index : int = randi_range(0,2)
	coin_collect_sounds[sounds_index].play()
	Singleton.coin_count += 1
	collected_coin.queue_free()

func _on_death():
	$Sounds/death_sound.play()
	$Player/Sprite2D.texture = load("res://art/player_dead.png")
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = true
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_coin_spawn_timer_timeout():
	var COIN_SCENE = load("res://scenes/coin.tscn")
	var coin = COIN_SCENE.instantiate()
	
	var random_position_x : float = randf_range(0,viewport_size.x)
	var random_position_y : float = randf_range(0,viewport_size.y)
	
	coin.global_position = Vector2(random_position_x, random_position_y)
	
	$SpawnedCoins.add_child(coin, true)
	
	#disappear coin
	await get_tree().create_timer(disappear_time).timeout
	if is_instance_valid(coin):
		$Sounds/coin_disappear.play()
		coin.queue_free()

func _on_enemy_spawn_timer_timeout():
	var ENEMY_SCENE = load("res://scenes/enemy.tscn")
	var enemy = ENEMY_SCENE.instantiate()

	var random_position_x : float = randf_range(0,viewport_size.x)
	var random_position_y : float = randf_range(0,viewport_size.y)
	
	enemy.global_position = Vector2(random_position_x, random_position_y)
	
	$SpawnedEnemies.add_child(enemy, true)

	#disappear enemy
	await get_tree().create_timer(disappear_time).timeout
	if is_instance_valid(enemy):
		enemy.queue_free()

func _on_countdown_timer_timeout():
	Singleton.game_timer -= 1
	
	if Singleton.game_timer <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
