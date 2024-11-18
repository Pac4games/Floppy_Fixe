extends CharacterBody2D

@export var START_POS:Vector2 = Vector2(1229, 324)
@export var BULLET_SPEED:float = 500.0
@export var BULLET_OFFSET:float = 80.0
@export var BULLET_COOLDOWN:float = 1.5
@export var BULLET_ANGLE:float = 25.0
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
		var bullet_spread:Array
		bullet_spread.resize(3)

		var idx:int = 0
		for bullet in bullet_spread:
			bullet = projectile_scene.instantiate()
			bullet.spawnPos = global_position
			bullet.spawnPos.x -= BULLET_OFFSET
			bullet.speed = BULLET_SPEED

			match idx:
				0:
					bullet.dir = rotation
				1:
					bullet.dir = rotation + deg_to_rad(BULLET_ANGLE)
				2:
					bullet.dir = rotation + deg_to_rad(-BULLET_ANGLE)

			bullets.append(bullet)
			add_child(bullet)
			idx += 1

		timer.start(BULLET_COOLDOWN)
		await (timer.timeout)
		bullet_spread.clear()
	
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
