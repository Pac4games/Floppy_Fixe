extends Node

@onready var player:CharacterBody2D = $Fixe

@export var SCROLL_SPEED:int = 4
@export var GROUND_HEIGHT:int
@export var PIPE_DELAY:int = 100
@export var PIPE_RANGE:int = 200
@export var SCREEN_SIZE:Vector2i

var game_running:bool
var game_over:bool
var scroll:float
var score:int
var pipes:Array

func new_game() -> void:
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	player.reset()

func _ready() -> void:
	new_game()

func _input(event:InputEvent) -> void:
	if (not game_over):
		if (event.is_action_pressed("Flop")):
			pass
