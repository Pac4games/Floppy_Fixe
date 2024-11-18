extends CharacterBody2D

@export var START_POS:Vector2 = Vector2(1229, 324)
@export var BULLET_SPEED:float = 500.0
@export var BULLET_OFFSET:float = 80.0
@export var BULLET_COOLDOWN:float = 3.0
@export var BULLET_AMMO:int = 5

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var timer:Timer = $Timer
@onready var projectile_scene:PackedScene = load("res://scenes/projectile.tscn")

func wait_secs(time:float) -> void:
	timer.start(time)
	await (timer.timeout)

func spawn() -> void:
	animation_player.play("spawn")
	await (animation_player.animation_finished)
	await (bullet_phase())
	eel_phase()

func bullet_phase() -> int:
	var bullets:Array

	for i in BULLET_AMMO:
		var bullet:Node2D = projectile_scene.instantiate()
		bullet.spawnPos = global_position
		bullet.spawnPos.x -= BULLET_OFFSET
		bullet.speed = BULLET_SPEED
		bullets.append(bullet)
		add_child(bullet)
		timer.start(BULLET_COOLDOWN)
		await (timer.timeout)
	
	timer.start(BULLET_COOLDOWN)
	await (timer.timeout)
	for bullet in bullets:
		bullet.queue_free()
	bullets.clear()

	return (1)

func eel_phase() -> void:
	print("EEEEEL")

func _ready() -> void:
	position = START_POS
	spawn()
