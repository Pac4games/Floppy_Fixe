extends Node

@onready var player:CharacterBody2D = $Fixe
@onready var ground:Area2D = $Ground
@onready var timer:Timer = $PipeTimer

@export var pipe_scene:PackedScene
@export var SCROLL_SPEED:int = 4
@export var PIPE_DELAY:int = 100
@export var PIPE_RANGE:int = 200

var game_running:bool
var game_over:bool
var scroll:float
var score:int
var ground_height:int
var pipes:Array
var screen_size:Vector2i

func new_game() -> void:
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	pipes.clear()
	generate_pipes()
	player.reset()

func start_game() -> void:
	game_running = true
	player.flying = true
	player.flop()
	timer.start()

func player_hit() -> void:
	pass

func generate_pipes() -> void:
	var pipe:Node2D = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (float(screen_size.y - ground_height) / 2 ) + randi_range(-PIPE_RANGE, PIPE_RANGE) 
	pipe.hit.connect(player_hit)
	add_child(pipe)
	pipes.append(pipe)

func _on_pipe_timer_timeout() -> void:
	generate_pipes()

func _ready() -> void:
	screen_size = get_window().size
	ground_height = ground.get_node("Sprite2D").texture.get_height()
	new_game()

func _physics_process(_delta:float) -> void:
	if (!game_over):
		if (Input.is_action_just_pressed("Flop")):
			if (!game_running):
				start_game()
			elif player.flying:
				player.flop()

func _process(_delta:float) -> void:
	if (game_running):
		scroll += SCROLL_SPEED
		# Reset ground scroll
		if (scroll >= screen_size.x):
			scroll = 0
		ground.position.x = -scroll

		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
