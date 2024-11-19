extends Node

@export var SCROLL_SPEED:int = 4
@export var PIPE_DELAY:int = 100
@export var PIPE_RANGE:int = 125
@export var MAX_NUM_OF_PIPES_ON_SCREEN:int = 5

@onready var player:CharacterBody2D = $Fixe
@onready var ground:Area2D = $Ground
@onready var timer:Timer = $PipeTimer
@onready var score_label:Label = $ScoreLabel
@onready var save_manager:Node = $SaveManager
@onready var game_over_menu:CanvasLayer = $GameOver
@onready var pipe_scene:PackedScene = load("res://scenes/pipe.tscn")
@onready var boss_scene:PackedScene = load("res://scenes/skeelie.tscn")
@onready var boss:Node2D

var game_running:bool
var game_over:bool
var boss_spawned:bool
var scroll:float
var score:int
var ground_height:int
var pipes:Array
var screen_size:Vector2i

func _ready() -> void:
	screen_size = get_window().size
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	new_game()

func _process(_delta:float) -> void:
	if (game_running):
		scroll += SCROLL_SPEED
		# Reset ground scroll
		if (scroll >= screen_size.x):
			scroll = 0
		ground.position.x = -scroll

		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

		if (pipes.size() >= MAX_NUM_OF_PIPES_ON_SCREEN):
			pipes[0].queue_free()
			pipes.pop_front()

		if (score == 2 && !boss_spawned):
			spawn_boss()

func _physics_process(_delta:float) -> void:
	if (!game_over):
		if (Input.is_action_just_pressed("Flop")):
			if (!game_running):
				start_game()
			elif (player.flying):
				player.flop()
				check_top()

func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func _on_ground_hit() -> void:
	player.falling = false
	if (!game_over):
		stop_game()

func _on_game_over_restart() -> void:
	if (boss_spawned):
		boss.clear_bullets()
		boss.queue_free()
	get_tree().reload_current_scene()

func new_game() -> void:
	game_running = false
	game_over = false
	boss_spawned = false
	scroll = 0
	score = 0
	score_label.text = str(score)
	generate_pipes()
	player.reset()

func start_game() -> void:
	game_running = true
	player.flying = true
	player.animation_player.stop()
	player.flop()
	timer.start()
	score_label.show()

func stop_game() -> void:
	timer.stop()
	player.death_sfx.play()
	player.flying = false
	game_running = false
	game_over = true
	save_manager.check_highscore(score)
	game_over_menu.display_scores(score, save_manager.highscore)
	game_over_menu.show()

func player_hit() -> void:
	player.falling = true
	if (!game_over):
		stop_game()

func player_scored() -> void:
	if (!player.falling):
		score += 1
		score_label.text = str(score)

func generate_pipes() -> void:
	if (!boss_spawned):
		var pipe:Node2D = pipe_scene.instantiate()
		pipe.position.x = screen_size.x + PIPE_DELAY
		pipe.position.y = (float(screen_size.y - ground_height) / 2 ) + randi_range(-PIPE_RANGE, PIPE_RANGE) 
		pipe.hit.connect(player_hit)
		pipe.scored.connect(player_scored)
		add_child(pipe)
		pipes.append(pipe)

func check_top() -> void:
	if (player.position.y < 0):
		player.falling = true
		stop_game()

func spawn_boss() -> void:
	boss = boss_scene.instantiate()
	add_child(boss)
	boss_spawned = true
