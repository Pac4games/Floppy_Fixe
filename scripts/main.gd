extends Node

@onready var player:CharacterBody2D = $Fixe
@onready var ground:Area2D = $Ground

@export var SCROLL_SPEED:int = 4
@export var GROUND_HEIGHT:int
@export var PIPE_DELAY:int = 100
@export var PIPE_RANGE:int = 200

var game_running:bool
var game_over:bool
var scroll:float
var score:int
var pipes:Array
var screen_size:Vector2i

func new_game() -> void:
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	player.reset()

func start_game() -> void:
	game_running = true
	player.flying = true
	player.flop()

func _ready() -> void:
	screen_size = get_window().size
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
		if scroll >= screen_size.x:
			scroll = 0

		ground.position.x = -scroll
